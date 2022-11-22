import React, { useState } from 'react';
import { isNil } from 'ramda';

import ReactCrop, { makeAspectCrop, centerCrop } from 'react-image-crop';
import { Button } from '@material-ui/core';
import PropTypes from 'prop-types';

import 'react-image-crop/dist/ReactCrop.css';
import useStyles from './useStyles';

function ImageUpload({ onUpload }) {
  const styles = useStyles();

  const DEFAULT_CROP_PARAMS = {
    unit: '%',
    width: 90,
  };

  const [fileAsBase64, changeFileAsBase64] = useState(null);
  const [cropParams, changeCropParams] = useState(DEFAULT_CROP_PARAMS);
  const [file, changeFile] = useState(null);
  const [image, changeImage] = useState(null);

  const handleCropComplete = (newCrop, newPercentageCrop) => {
    changeCropParams(newPercentageCrop);
  };

  const onImageLoaded = (loadedImage) => {
    const { naturalWidth: width, naturalHeight: height } = loadedImage.target;

    const newCropParams = centerCrop(
      makeAspectCrop(
        {
          ...DEFAULT_CROP_PARAMS,
        },
        16 / 9,
        width,
        height,
      ),
      width,
      height,
    );

    changeCropParams(newCropParams);
    changeImage(loadedImage);
  };

  const getActualCropParameters = (width, height, params) => ({
    cropX: (params.x * width) / 100,
    cropY: (params.y * height) / 100,
    cropWidth: (params.width * width) / 100,
    cropHeight: (params.height * height) / 100,
  });

  const handleCropChange = (_, newCropParams) => {
    changeCropParams(newCropParams);
  };

  const handleSave = () => {
    const { naturalWidth: width, naturalHeight: height } = image.target;
    const actualCropParams = getActualCropParameters(width, height, cropParams);

    onUpload({ attachment: { ...actualCropParams, image: file } });
  };

  const handleImageRead = (newImage) => {
    changeFileAsBase64(newImage.target.result);
  };

  const handleLoadFile = (e) => {
    e.preventDefault();

    const [acceptedFile] = e.target.files;

    const fileReader = new FileReader();

    fileReader.onload = handleImageRead;
    fileReader.readAsDataURL(acceptedFile);

    changeFile(acceptedFile);
  };

  return fileAsBase64 ? (
    <div className={styles.imageBlockWrapper}>
      <div className={styles.crop}>
        <ReactCrop
          className={styles.reactCrop}
          crop={cropParams}
          onChange={handleCropChange}
          onComplete={handleCropComplete}
          keepSelection
        >
          <img alt="Crop me" src={fileAsBase64} onLoad={onImageLoaded} />
        </ReactCrop>
      </div>

      <Button
        className={styles.button}
        variant="contained"
        size="small"
        color="primary"
        disabled={isNil(fileAsBase64)}
        onClick={handleSave}
      >
        Save
      </Button>
    </div>
  ) : (
    <label htmlFor="imageUpload">
      <Button variant="contained" size="small" color="primary" component="span">
        Add Image
      </Button>
      <input accept="image/*" id="imageUpload" type="file" onChange={handleLoadFile} hidden />
    </label>
  );
}

ImageUpload.propTypes = {
  onUpload: PropTypes.func.isRequired,
};

export default ImageUpload;
