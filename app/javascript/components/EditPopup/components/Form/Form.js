import React from 'react';
import PropTypes from 'prop-types';
import { has, isNil } from 'ramda';

import TextField from '@material-ui/core/TextField';
import { Button } from '@material-ui/core';

import useStyles from './useStyles';
import UserSelect from 'components/UserSelect/UserSelect';
import TaskPresenter from 'presenters/TaskPresenter';
import ImageUpload from 'components/ImageUpload/ImageUpload';

function Form({ errors, onChange, task, onAttachImage, onDetachImage }) {
  const styles = useStyles();
  const handleChangeTextField = (fieldName) => (event) => onChange({ ...task, [fieldName]: event.target.value });
  const handleChangeSelect = (fieldName) => (user) => onChange({ ...task, [fieldName]: user });

  const handleCardAttach = (image) => {
    onAttachImage(task.id, image).catch((error) => {
      alert(`Destrucion Failed! Error: ${error.message}`);
    });
  };

  const handleCardDetach = () => {
    onDetachImage(task).catch((error) => {
      alert(`Destrucion Failed! Error: ${error.message}`);
    });
  };

  return (
    <form className={styles.root}>
      <TextField
        error={has('name', errors)}
        helperText={errors.name}
        onChange={handleChangeTextField('name')}
        value={TaskPresenter.name(task)}
        label="Name"
        required
        margin="dense"
      />
      <TextField
        error={has('description', errors)}
        helperText={errors.description}
        onChange={handleChangeTextField('description')}
        value={TaskPresenter.description(task)}
        label="Description"
        required
        multiline
        margin="dense"
      />
      <UserSelect
        label="Author"
        value={TaskPresenter.author(task)}
        onChange={handleChangeSelect('author')}
        isDisabled
        isRequired
        error={has('author', errors)}
        helperText={errors.author}
      />
      <UserSelect
        label="Assignee"
        value={TaskPresenter.assignee(task)}
        onChange={handleChangeSelect('assignee')}
        isDisabled={false}
        isRequired
        error={has('assignee', errors)}
        helperText={errors.assignee}
      />
      {isNil(TaskPresenter.imageUrl(task)) ? (
        <div className={styles.imageUploadContainer}>
          <ImageUpload onUpload={handleCardAttach} />
        </div>
      ) : (
        <div className={styles.previewContainer}>
          <img className={styles.preview} src={TaskPresenter.imageUrl(task)} alt="Attachment" />
          <Button className={styles.button} variant="contained" size="small" color="primary" onClick={handleCardDetach}>
            Remove image
          </Button>
        </div>
      )}
    </form>
  );
}

Form.propTypes = {
  onChange: PropTypes.func.isRequired,
  onAttachImage: PropTypes.func.isRequired,
  onDetachImage: PropTypes.func.isRequired,
  task: TaskPresenter.shape().isRequired,
  errors: PropTypes.shape({
    name: PropTypes.arrayOf(PropTypes.string),
    description: PropTypes.arrayOf(PropTypes.string),
    author: PropTypes.arrayOf(PropTypes.string),
    assignee: PropTypes.arrayOf(PropTypes.string),
  }),
};

Form.defaultProps = {
  errors: {},
};

export default Form;
