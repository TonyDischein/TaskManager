import React, { useEffect, useState } from 'react';
import { propOr } from 'ramda';

import Task from 'components/Task';
import TasksRepository from 'repositories/TasksRepository';
import ColumnHeader from 'components/ColumnHeader';
import useStyles from './useStyles';
import TaskForm from 'forms/TaskForm';
import AddPopup from 'components/AddPopup';
import EditPopup from 'components/EditPopup';

import KanbanBoard from '@lourenci/react-kanban';
import '@lourenci/react-kanban/dist/styles.css';
import { Fab } from '@material-ui/core';
import AddIcon from '@material-ui/icons/Add';

const STATES = [
  { key: 'new_task', value: 'New' },
  { key: 'in_development', value: 'In Dev' },
  { key: 'in_qa', value: 'In QA' },
  { key: 'in_code_review', value: 'in CR' },
  { key: 'ready_for_release', value: 'Ready for release' },
  { key: 'released', value: 'Released' },
  { key: 'archived', value: 'Archived' },
];

const MODES = {
  ADD: 'add',
  EDIT: 'edit',
  NONE: 'none',
};

const initialBoard = {
  columns: STATES.map((column) => ({
    id: column.key,
    title: column.value,
    cards: [],
    meta: {},
  })),
};

function TaskBoard() {
  const [board, setBoard] = useState(initialBoard);
  const [boardCards, setBoardCards] = useState([]);
  const [mode, setMode] = useState(MODES.NONE);
  const [openedTaskId, setOpenedTaskId] = useState(null);

  const styles = useStyles();

  const loadColumn = (state, page, perPage) =>
    TasksRepository.index({
      q: { stateEq: state },
      page,
      perPage,
    });

  const loadColumnInitial = (state, page = 1, perPage = 10) => {
    loadColumn(state, page, perPage).then(({ data }) => {
      setBoardCards((prevState) => ({
        ...prevState,
        [state]: { cards: data.items, meta: data.meta },
      }));
    });
  };

  const loadBoard = () => {
    STATES.map(({ key }) => loadColumnInitial(key));
  };

  const generateBoard = () => {
    const taskBoard = {
      columns: STATES.map(({ key, value }) => ({
        id: key,
        title: value,
        cards: propOr({}, 'cards', boardCards[key]),
        meta: propOr({}, 'meta', boardCards[key]),
      })),
    };

    setBoard(taskBoard);
  };

  const loadColumnMore = (state, page = 1, perPage = 10) => {
    loadColumn(state, page, perPage).then(({ data }) => {
      setBoardCards((prevState) => ({
        ...prevState,
        [state]: { cards: [...prevState[state].cards, ...data.items], meta: data.meta },
      }));
    });
  };

  const handleCardDragEnd = (task, source, destination) => {
    const transition = task.transitions.find(({ to }) => destination.toColumnId === to);
    if (!transition) {
      return null;
    }

    return TasksRepository.update(task.id, { stateEvent: transition.event })
      .then(() => {
        loadColumnInitial(destination.toColumnId);
        loadColumnInitial(source.fromColumnId);
      })
      .catch((error) => {
        alert(`Move failed! ${error.message}`);
      });
  };

  const handleOpenAddPopup = () => {
    setMode(MODES.ADD);
  };

  const handleClose = () => {
    setMode(MODES.NONE);

    setOpenedTaskId(null);
  };

  const handleTaskCreate = (params) => {
    const attributes = TaskForm.attributesToSubmit(params);

    return TasksRepository.create(attributes).then(({ data: { task } }) => {
      loadColumnInitial(task.state);

      handleClose();
    });
  };

  const loadTask = (id) => TasksRepository.show(id).then(({ data: { task } }) => task);

  const handleTaskUpdate = (task) => {
    const attributes = TaskForm.attributesToSubmit(task);

    return TasksRepository.update(attributes).then(() => {
      loadColumnInitial(task.state);
      handleClose();
    });
  };

  const handleTaskDestroy = (task) =>
    TasksRepository.destroy(task.id).then(() => {
      loadColumnInitial(task.state);

      handleClose();
    });

  const handleOpenEditPopup = (task) => {
    setOpenedTaskId(task.id);
    setMode(MODES.EDIT);
  };

  useEffect(() => loadBoard(), []);
  useEffect(() => generateBoard(), [boardCards]);

  return (
    <>
      <Fab onClick={handleOpenAddPopup} className={styles.addButton} color="primary" aria-label="add">
        <AddIcon />
      </Fab>

      <KanbanBoard
        disableColumnDrag
        onCardDragEnd={handleCardDragEnd}
        renderColumnHeader={(column) => <ColumnHeader column={column} onLoadMore={loadColumnMore} />}
        renderCard={(card) => <Task onClick={handleOpenEditPopup} task={card} />}
      >
        {board}
      </KanbanBoard>

      {mode === MODES.ADD && <AddPopup onCreateCard={handleTaskCreate} onClose={handleClose} />}
      {mode === MODES.EDIT && (
        <EditPopup
          cardId={openedTaskId}
          onLoadCard={loadTask}
          onCardUpdate={handleTaskUpdate}
          onCardDestroy={handleTaskDestroy}
          onClose={handleClose}
        />
      )}
    </>
  );
}

export default TaskBoard;
