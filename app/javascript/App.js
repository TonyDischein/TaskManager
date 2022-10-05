import React from 'react';

import store from 'store';
import { Provider } from 'react-redux';
import TaskBoard from 'containers/TaskBoard';
import { MuiThemeProvider } from '@material-ui/core';
import MUITheme from 'MUITheme/MUITheme';

function App() {
  return (
    <Provider store={store}>
      <MuiThemeProvider theme={MUITheme}>
        <TaskBoard />
      </MuiThemeProvider>
    </Provider>
  );
}

export default App;
