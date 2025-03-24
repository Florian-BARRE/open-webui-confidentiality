import { WEBUI_BASE_URL } from '$lib/constants';
import { TTS_RESPONSE_SPLIT } from '$lib/types';

//////////////////////////
// Helper functions
//////////////////////////

/**
 * Checks if the model is confidential based on its name.
 * @param model - An object containing a 'name' property.
 * @returns true if the model name starts with "confidential", false otherwise.
 */
export const isModelConfidential = (model: any): boolean | undefined => {
	if (!model || typeof model.name !== 'string') {
		console.error('isModelConfidential: Invalid model provided:', model);
		return false;
	}

	if (model.name.startsWith('non-confidential')) {
		return false;
	} else if (model.name.startsWith('confidential')) {
		return true;
	}

	console.error('isModelConfidential: Unable to determine confidentiality from model name:', model.name);
	return undefined;
};

/**
 * Extracts the model name by removing either the "confidential" or "non-confidential" prefix,
 * along with an optional period immediately following the prefix.
 * An optional parameter can be provided to explicitly specify the model's confidentiality.
 * If provided, this parameter takes priority over checking the model's name.
 * Additionally, if the model is confidential, a lock emoji is prepended to the name.
 *
 * @param model - An object containing a 'name' property.
 * @param isConfidential - (Optional) Boolean indicating if the model is confidential.
 * @returns The cleaned model name, with a lock emoji if confidential.
 */
export const extractModelName = (model: any, isConfidential?: boolean): string => {
	if (!model || typeof model.name !== 'string') {
		console.error('extractModelName: Invalid model provided:', model);
		return '';
	}

	let modelName: string = model.name;
	let confidentialFlag: boolean;

	if (typeof isConfidential === 'boolean') {
		confidentialFlag = isConfidential;
		// Remove the prefix with an optional period following it.
		modelName = confidentialFlag
			? modelName.replace(/^confidential\.?/, '')
			: modelName.replace(/^non-confidential\.?/, '');
	} else {
		if (modelName.startsWith('confidential')) {
			confidentialFlag = true;
			modelName = modelName.replace(/^confidential\.?/, '');
		} else if (modelName.startsWith('non-confidential')) {
			confidentialFlag = false;
			modelName = modelName.replace(/^non-confidential\.?/, '');
		} else {
			console.warn('extractModelName: Model name does not have a confidentiality prefix:', modelName);
			confidentialFlag = false;
		}
	}

	modelName = modelName.trim();

	// Prepend a lock emoji if the model is confidential.
	if (confidentialFlag) {
		modelName = `🔒 ${modelName}`;
	}

	return modelName;
};
