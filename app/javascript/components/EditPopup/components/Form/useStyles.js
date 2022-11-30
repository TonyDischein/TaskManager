import { makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles(() => ({
  root: {
    display: 'flex',
    flexDirection: 'column',
  },
  previewContainer: {
    display: 'flex',
    flexDirection: 'column',
    alignContent: 'center',
    padding: 10,
  },
  preview: {
    maxWidth: '100%',
  },
  button: {
    display: 'flex',
    alignSelf: 'start',
    marginTop: 8,
  },
}));

export default useStyles;
