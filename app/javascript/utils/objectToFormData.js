import { serialize } from 'object-to-formdata';

export const objectToFormData = (body) => serialize(body);
