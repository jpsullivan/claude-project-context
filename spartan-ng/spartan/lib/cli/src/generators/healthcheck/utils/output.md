/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/utils/prompt.ts
```typescript
export function promptUser(question: string): Promise<boolean> {
	return new Promise((resolve) => {
		process.stdout.write(`${question} (y/n): `);

		process.stdin.setEncoding('utf8');
		process.stdin.once('data', (data) => {
			const answer = data.toString().trim().toLowerCase();
			if (['yes', 'y'].includes(answer)) {
				resolve(true);
			} else if (['no', 'n'].includes(answer)) {
				resolve(false);
			} else {
				console.log('Invalid response. Please answer with "yes" or "no".');
				resolve(promptUser(question));
			}
		});
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/utils/reporter.ts
```typescript
import { logger } from '@nx/devkit';
import pc from 'picocolors';
import { HealthcheckReport, HealthcheckSeverity, HealthcheckStatus } from '../healthchecks';

export function printReport(report: HealthcheckReport): void {
	logger.log(`${getStatus(report.status)} ${report.name}`);

	// if this was a failure log the instructions
	if (report.status === HealthcheckStatus.Failure) {
		for (const issue of report.issues) {
			logger.log(`\t\t ${getSeverity(issue.severity)} ${issue.details}`);
		}
	}

	// if the healthcheck was skipped, log the reason
	if (report.status === HealthcheckStatus.Skipped) {
		logger.log(`\t\t ${pc.yellow(report.reason)}`);
	}
}

function getStatus(result: HealthcheckStatus) {
	switch (result) {
		case HealthcheckStatus.Success:
			return pc.green('[ ✔ ]');
		case HealthcheckStatus.Failure:
			return pc.red('[ ✖ ]');
		case HealthcheckStatus.Skipped:
			return pc.yellow('[ ! ]');
	}
}

function getSeverity(severity: HealthcheckSeverity) {
	switch (severity) {
		case HealthcheckSeverity.Error:
			return pc.red('✖');
		case HealthcheckSeverity.Warning:
			return pc.yellow('!');
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/utils/runner.ts
```typescript
import { Tree } from '@nx/devkit';
import {
	Healthcheck,
	HealthcheckFailureFn,
	HealthcheckReport,
	HealthcheckSeverity,
	HealthcheckStatus,
	isHealthcheckFixable,
} from '../healthchecks';

export async function runHealthcheck(tree: Tree, healthcheck: Healthcheck): Promise<HealthcheckReport> {
	const report: HealthcheckReport = {
		name: healthcheck.name,
		status: HealthcheckStatus.Success,
		fixable: false,
		healthcheck,
	};

	const failure: HealthcheckFailureFn = (details: string, severity: HealthcheckSeverity, fixable: boolean) => {
		// check if this issue already exists
		if (report.issues?.some((issue) => issue.details === details)) {
			return;
		}

		report.status = HealthcheckStatus.Failure;
		report.issues ??= [];
		report.issues.push({ details, severity });
		report.fixable = report.fixable || (fixable && isHealthcheckFixable(healthcheck));
	};

	const skip = (reason: string) => {
		report.status = HealthcheckStatus.Skipped;
		report.reason = reason;
	};

	await coercePromise(healthcheck.detect(tree, failure, skip));

	return report;
}

function coercePromise<T>(value: T | Promise<T>): Promise<T> {
	return value instanceof Promise ? value : Promise.resolve(value);
}

```
