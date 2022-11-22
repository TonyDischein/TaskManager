import humps from 'humps';

export const decamelize = (obj) => humps.decamelizeKeys(obj);
export const camelize = (obj) => humps.camelizeKeys(obj);

export const decamelizeFormData = (obj) => {
  const file = obj.image ? obj.image.attachment.image : {};
  const decamelizeObject = humps.decamelizeKeys(obj);
  decamelizeObject.image.attachment.image = file;

  return decamelizeObject;
};
