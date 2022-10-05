import { useSelector } from 'react-redux';
import { useTasksActions } from 'slices/TasksSlice';

const useTasks = () => {
  const board = useSelector((state) => state.TasksSlice.board);

  const { loadBoard, loadColumnMore, dragEndCard, createTask, updateTask, loadTask, destroyTask } = useTasksActions();

  return {
    board,
    loadBoard,
    loadColumnMore,
    dragEndCard,
    createTask,
    updateTask,
    loadTask,
    destroyTask,
  };
};

export default useTasks;
