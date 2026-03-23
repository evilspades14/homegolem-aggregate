<script lang="ts">
	import * as NavigationMenu from '$lib/components/ui/navigation-menu/index.js';
</script>

<div class="p-2 justify-items-end border-b">
	<NavigationMenu.Root>
		<NavigationMenu.List>
			<NavigationMenu.Item>
				<NavigationMenu.Link href="/">Home</NavigationMenu.Link>
			</NavigationMenu.Item>
            <NavigationMenu.Item>
				<NavigationMenu.Link href="/about">About</NavigationMenu.Link>
			</NavigationMenu.Item>
			<NavigationMenu.Item>
				<NavigationMenu.Link href="/experience">Experience</NavigationMenu.Link>
			</NavigationMenu.Item>
            <NavigationMenu.Item>
				<NavigationMenu.Link href="/contact">Contact</NavigationMenu.Link>
			</NavigationMenu.Item>
		</NavigationMenu.List>
	</NavigationMenu.Root>
</div>
