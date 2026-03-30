<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import { browser } from '$app/environment';

	let canvas: HTMLCanvasElement;
	let animFrame: number;

	onMount(() => {
		const ctx = canvas.getContext('2d') as CanvasRenderingContext2D;
		const dpr = window.devicePixelRatio ?? 1;
		const W = window.innerWidth;
		const H = window.innerHeight;

		canvas.width = W * dpr;
		canvas.height = H * dpr;
		canvas.style.width = `${W}px`;
		canvas.style.height = `${H}px`;

		ctx.scale(dpr, dpr);

		interface Point {
			x: number;
			y: number;
			ox: number;
			oy: number;
			phase: number;
			amp: number;
			isMouse?: boolean;
		}

		interface Triangle {
			a: number;
			b: number;
			c: number;
		}

		const N = 58;
		let pts: Point[] = [];
		let tris: Triangle[] = [];
		let frame = 0;
		let lastTri = -999;

		// Mouse state
		let mouseX = W / 2;
		let mouseY = H / 2;
		let mouseActive = false;

		function onMouseMove(e: MouseEvent) {
			mouseX = e.clientX;
			mouseY = e.clientY;
			mouseActive = true;
		}
		function onMouseLeave() {
			mouseActive = false;
		}

		window.addEventListener('mousemove', onMouseMove);
		window.addEventListener('mouseleave', onMouseLeave);

		function noise(x: number, y: number, t: number): number {
			return (
				Math.sin(x * 0.008 + t * 0.0007) * Math.cos(y * 0.009 - t * 0.0005) +
				Math.sin(x * 0.015 - t * 0.0004 + 1.2) * Math.sin(y * 0.013 + t * 0.0006 + 0.8) * 0.5
			);
		}

		for (let i = 0; i < N; i++) {
			pts.push({
				x: Math.random() * W,
				y: Math.random() * H,
				ox: 0,
				oy: 0,
				phase: Math.random() * Math.PI * 2,
				amp: 30 + Math.random() * 50
			});
		}
		for (const p of pts) {
			p.ox = p.x;
			p.oy = p.y;
		}

		// Add mouse node as last point
		pts.push({
			x: mouseX,
			y: mouseY,
			ox: mouseX,
			oy: mouseY,
			phase: 0,
			amp: 0,
			isMouse: true
		});

		function circumcircle(ax: number, ay: number, bx: number, by: number, cx: number, cy: number) {
			const D = 2 * (ax * (by - cy) + bx * (cy - ay) + cx * (ay - by));
			if (Math.abs(D) < 1e-10) return null;
			const ux =
				((ax * ax + ay * ay) * (by - cy) +
					(bx * bx + by * by) * (cy - ay) +
					(cx * cx + cy * cy) * (ay - by)) /
				D;
			const uy =
				((ax * ax + ay * ay) * (cx - bx) +
					(bx * bx + by * by) * (ax - cx) +
					(cx * cx + cy * cy) * (bx - ax)) /
				D;
			return { x: ux, y: uy, r: Math.hypot(ax - ux, ay - uy) };
		}

		function triangulate(points: Point[]): Triangle[] {
			const sM = Math.max(W, H) * 10;
			const sp: Point[] = [
				{ x: -sM, y: -sM, ox: 0, oy: 0, phase: 0, amp: 0 },
				{ x: sM * 3, y: -sM, ox: 0, oy: 0, phase: 0, amp: 0 },
				{ x: 0, y: sM * 3, ox: 0, oy: 0, phase: 0, amp: 0 }
			];
			const all = [...sp, ...points];
			let ts: Triangle[] = [{ a: 0, b: 1, c: 2 }];

			for (let pi = 3; pi < all.length; pi++) {
				const p = all[pi];
				const bad: Triangle[] = [];
				const poly: [number, number][] = [];

				for (const t of ts) {
					const cc = circumcircle(
						all[t.a].x, all[t.a].y,
						all[t.b].x, all[t.b].y,
						all[t.c].x, all[t.c].y
					);
					if (cc && Math.hypot(p.x - cc.x, p.y - cc.y) < cc.r) bad.push(t);
				}
				for (const t of bad) {
					for (const [e0, e1] of [
						[t.a, t.b],
						[t.b, t.c],
						[t.c, t.a]
					] as [number, number][]) {
						const shared = bad.some(
							(bt) =>
								bt !== t &&
								(bt.a === e0 || bt.b === e0 || bt.c === e0) &&
								(bt.a === e1 || bt.b === e1 || bt.c === e1)
						);
						if (!shared) poly.push([e0, e1]);
					}
				}
				ts = ts.filter((t) => !bad.includes(t));
				for (const [e0, e1] of poly) ts.push({ a: e0, b: e1, c: pi });
			}
			return ts
				.filter((t) => t.a >= 3 && t.b >= 3 && t.c >= 3)
				.map((t) => ({ a: t.a - 3, b: t.b - 3, c: t.c - 3 }));
		}

		function draw() {
			frame++;

			// Update regular nodes
			for (const p of pts) {
				if (p.isMouse) {
					// Smoothly lerp mouse node toward actual cursor
					p.x += (mouseX - p.x) * 0.12;
					p.y += (mouseY - p.y) * 0.12;
					p.ox = p.x;
					p.oy = p.y;
				} else {
					p.x = p.ox + noise(p.ox, p.oy, frame + p.phase * 100) * p.amp;
					p.y = p.oy + noise(p.ox + 500, p.oy + 500, frame + p.phase * 100 + 50) * p.amp;
				}
			}

			if (frame - lastTri > 4) {
				tris = triangulate(pts);
				lastTri = frame;
			}

			ctx.fillStyle = '#0a0a0a';
			ctx.fillRect(0, 0, W, H);

			for (const t of tris) {
				const a = pts[t.a], b = pts[t.b], c = pts[t.c];
				const mx = (a.x + b.x + c.x) / 3,
					my = (a.y + b.y + c.y) / 3;
				if (mx < -60 || mx > W + 60 || my < -60 || my > H + 60) continue;
				const maxE = Math.max(
					Math.hypot(a.x - b.x, a.y - b.y),
					Math.hypot(b.x - c.x, b.y - c.y),
					Math.hypot(c.x - a.x, c.y - a.y)
				);
				if (maxE > 280) continue;

				const ef = Math.max(0, 1 - maxE / 280);
				const heat = Math.max(
					0,
					1 - (Math.hypot(mx - W / 2, my - H / 2) / Math.hypot(W / 2, H / 2)) * 1.4
				);

				// Boost triangles that include the mouse node
				const hasMouse = t.a === pts.length - 1 || t.b === pts.length - 1 || t.c === pts.length - 1;
				const mouseBoost = hasMouse && mouseActive ? 0.5 : 0;

				ctx.beginPath();
				ctx.moveTo(a.x, a.y);
				ctx.lineTo(b.x, b.y);
				ctx.lineTo(c.x, c.y);
				ctx.closePath();
				ctx.fillStyle = `rgba(${Math.round(40 + heat * 60)},${Math.round(heat * 20)},0,${0.02 + heat * 0.04 + mouseBoost * 0.08})`;
				ctx.fill();
				ctx.strokeStyle = `rgba(${Math.round(120 + heat * 135)},${Math.round(60 + heat * 35)},20,${0.12 + ef * 0.3 + mouseBoost * 0.4})`;
				ctx.lineWidth = 0.5 + heat * 0.4 + mouseBoost * 1.2;
				ctx.stroke();
			}

			for (const p of pts) {
				const heat = Math.max(
					0,
					1 - (Math.hypot(p.x - W / 2, p.y - H / 2) / Math.hypot(W / 2, H / 2)) * 1.4
				);
				if (p.isMouse) {
					if (!mouseActive) continue; // hide dot when cursor is off-screen
					// Render mouse node as a brighter, slightly larger dot
					ctx.beginPath();
					ctx.arc(p.x, p.y, 3, 0, Math.PI * 2);
					ctx.fillStyle = `rgba(255, 180, 60, 0.95)`;
					ctx.fill();
				} else {
					ctx.beginPath();
					ctx.arc(p.x, p.y, 1.5, 0, Math.PI * 2);
					ctx.fillStyle = `rgba(255,${Math.round(80 + heat * 40)},0,${0.3 + heat * 0.6})`;
					ctx.fill();
				}
			}

			animFrame = requestAnimationFrame(draw);
		}

		draw();

		return () => {
			window.removeEventListener('mousemove', onMouseMove);
			window.removeEventListener('mouseleave', onMouseLeave);
		};
	});

	onDestroy(() => {
		if (browser) cancelAnimationFrame(animFrame);
	});
</script>

<canvas bind:this={canvas}></canvas>

<style>
	canvas {
		position: fixed;
		top: 0;
		left: 0;
		width: 100dvw;
		height: 100dvh;
		z-index: -1;
		display: block;
	}
</style>