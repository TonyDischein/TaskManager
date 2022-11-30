import { makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles(() => ({
  crop: {
    maxHeight: 300,
    maxWidth: 300,
  },
  imageBlockWrapper: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    flexDirection: 'column',
    padding: 8,
  },
  reactCrop: {
    maxHeight: 'inherit',
  },
  button: {
    alignSelf: 'start',
    padding: 8,
  },
}));

export default useStyles;
