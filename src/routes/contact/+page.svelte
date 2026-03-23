<script>
	import { HugeiconsIcon } from '@hugeicons/svelte';
	import { SmartPhone01Icon } from '@hugeicons/core-free-icons';
	import { Mail01Icon } from '@hugeicons/core-free-icons';

	const phone = '910-489-6263';
	const email = 'jackson@homegolem.net';
</script>

<div class="grid grid-cols-2">
	<div class="space-y-8">
		<h1 class="text-4xl tracking-tight">Get in touch</h1>
		<div class="flex flex-col gap-6">
			<a href={`tel:${phone}`} class="group flex items-center gap-3">
				<HugeiconsIcon icon={SmartPhone01Icon} />
				<span class="group-hover:underline">{phone}</span>
			</a>
			<a href={`mailto:${email}`} class="group flex items-center gap-3">
				<HugeiconsIcon icon={Mail01Icon} />
				<span class="group-hover:underline">{email}</span>
			</a>
		</div>
	</div>
</div>
