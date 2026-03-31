<script lang="ts">
	import './layout.css';
	import favicon from '$lib/assets/favicon.svg';
	import { ModeWatcher } from "mode-watcher";
	// import NavBar from "$lib/components/NavBar.svelte";
	import DelaunayBackground from '$lib/components/DelaunayBackground.svelte';
	let { children } = $props();
</script>
<DelaunayBackground/>
<ModeWatcher />
<!-- <NavBar /> -->
<svelte:head><link rel="icon" href={favicon} /></svelte:head>
<div class="p-4 no-scrollbar h-dvh w-full">{@render children()}</div>

