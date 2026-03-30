<script>
	import * as Avatar from '$lib/components/ui/avatar/index.js';
	import { CardDescription, CardHeader, CardTitle } from '$lib/components/ui/card';
	import CardContent from '$lib/components/ui/card/card-content.svelte';
	import Card from '$lib/components/ui/card/card.svelte';
	import { Mail01Icon } from '@hugeicons/core-free-icons';
	import { HugeiconsIcon } from '@hugeicons/svelte';

	const email = 'jackson.homegolem@pm.me';
</script>

<main class="flex h-full w-full items-center justify-center">
	<Card class="bg-card/80">
		<CardContent class="relative w-xl flex-1 justify-center space-y-6 text-center ">
			<CardHeader class="relative w-full">
				<CardTitle class=" flex items-center gap-2 place-self-center text-3xl">
					<Avatar.Root class="size-12">
						<Avatar.Image src="/avatar.png" />
						<Avatar.Fallback>JH</Avatar.Fallback>
					</Avatar.Root>
				</CardTitle>
				<CardDescription>Jackson Holland</CardDescription>
			</CardHeader>
			<div class="flex justify-center">
				<a href={`mailto:${email}`} class="group flex items-center gap-3">
					<HugeiconsIcon icon={Mail01Icon} />
					<span class="group-hover:underline">{email}</span>
				</a>
			</div>
		</CardContent>
	</Card>
</main>
