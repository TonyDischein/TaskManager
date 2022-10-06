import React from 'react';
import { Provider } from 'react-redux';

import store from 'store';
import TaskBoard from 'containers/TaskBoard';
import MUITheme from 'MUITheme/MUITheme';

import { MuiThemeProvider } from '@material-ui/core';

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
