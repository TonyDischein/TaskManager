import routes from 'routes';
import FetchHelper from 'utils/fetchHelper';

export default {
  index(params) {
    const path = routes.apiV1TasksPath();

    return FetchHelper.get(path, params);
  },

  show(id) {
    const path = routes.apiV1TaskPath(id);

    return FetchHelper.get(path);
  },

  update(id, task = {}) {
    const path = routes.apiV1TaskPath(id);

    return FetchHelper.put(path, { task });
  },

  create(task = {}) {
    const path = routes.apiV1TasksPath();

    return FetchHelper.post(path, { task });
  },

  destroy(id) {
    const path = routes.apiV1TaskPath(id);

    return FetchHelper.delete(path, id);
  },

  attachImage(id, image = {}) {
    const path = routes.attachImageApiV1TaskPath(id);

    return FetchHelper.putFormData(path, image);
  },

  detachImage(id) {
    const path = routes.removeImageApiV1TaskPath(id);

    return FetchHelper.deleteFormData(path, id);
  },
};
