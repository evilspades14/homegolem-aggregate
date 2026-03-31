<script>
	import * as Avatar from '$lib/components/ui/avatar/index.js';
	import { CardDescription, CardHeader, CardTitle } from '$lib/components/ui/card';
	import CardContent from '$lib/components/ui/card/card-content.svelte';
	import Card from '$lib/components/ui/card/card.svelte';
	import { Mail01Icon } from '@hugeicons/core-free-icons';
	import { HugeiconsIcon } from '@hugeicons/svelte';

	const email = 'jackson.homegolem@pm.me';
</script>

<main class="h-full w-full flex items-center justify-center p-6">
	<Card class="w-full max-w-sm bg-card/80">
		<CardHeader class="text-center">
			<CardTitle class="flex place-self-center">
				<Avatar.Root class="size-12">
					<Avatar.Image src="/avatar.png" />
					<Avatar.Fallback>JH</Avatar.Fallback>
				</Avatar.Root>
			</CardTitle>
			<CardDescription>Jackson Holland</CardDescription>
		</CardHeader>
		<CardContent class="flex justify-center space-y-6 text-center">
			<a href={`mailto:${email}`} class="group flex items-center gap-3">
				<HugeiconsIcon icon={Mail01Icon} />
				<span class="group-hover:underline">{email}</span>
			</a>
		</CardContent>
	</Card>
</main>
