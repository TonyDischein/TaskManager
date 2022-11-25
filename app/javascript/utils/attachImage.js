const attachImage = (body, json) => {
  const image = json.attachment.image ? json.attachment.image : {};
  const data = body;
  data.attachment.image = image;

  return data;
};

export default attachImage;
