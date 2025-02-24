import { createReducer } from "@reduxjs/toolkit";
import {
  providerUpdateList,
  systemMarkTasksDirty,
  systemUpdateHealth,
  systemUpdateLanguages,
  systemUpdateLanguagesProfiles,
  systemUpdateLogs,
  systemUpdateReleases,
  systemUpdateSettings,
  systemUpdateStatus,
  systemUpdateTasks,
} from "../actions";
import { AsyncUtility } from "../utils";
import { createAsyncItemReducer } from "../utils/factory";

interface System {
  languages: Async.Item<Language.Server[]>;
  languagesProfiles: Async.Item<Language.Profile[]>;
  status: Async.Item<System.Status>;
  health: Async.Item<System.Health[]>;
  tasks: Async.Item<System.Task[]>;
  providers: Async.Item<System.Provider[]>;
  logs: Async.Item<System.Log[]>;
  releases: Async.Item<ReleaseInfo[]>;
  settings: Async.Item<Settings>;
}

const defaultSystem: System = {
  languages: AsyncUtility.getDefaultItem(),
  languagesProfiles: AsyncUtility.getDefaultItem(),
  status: AsyncUtility.getDefaultItem(),
  health: AsyncUtility.getDefaultItem(),
  tasks: AsyncUtility.getDefaultItem(),
  providers: AsyncUtility.getDefaultItem(),
  logs: AsyncUtility.getDefaultItem(),
  releases: AsyncUtility.getDefaultItem(),
  settings: AsyncUtility.getDefaultItem(),
};

const reducer = createReducer(defaultSystem, (builder) => {
  createAsyncItemReducer(builder, (s) => s.languages, {
    all: systemUpdateLanguages,
  });

  createAsyncItemReducer(builder, (s) => s.languagesProfiles, {
    all: systemUpdateLanguagesProfiles,
  });
  createAsyncItemReducer(builder, (s) => s.status, { all: systemUpdateStatus });
  createAsyncItemReducer(builder, (s) => s.settings, {
    all: systemUpdateSettings,
  });
  createAsyncItemReducer(builder, (s) => s.releases, {
    all: systemUpdateReleases,
  });
  createAsyncItemReducer(builder, (s) => s.logs, {
    all: systemUpdateLogs,
  });

  createAsyncItemReducer(builder, (s) => s.health, {
    all: systemUpdateHealth,
  });

  createAsyncItemReducer(builder, (s) => s.tasks, {
    all: systemUpdateTasks,
    dirty: systemMarkTasksDirty,
  });

  createAsyncItemReducer(builder, (s) => s.providers, {
    all: providerUpdateList,
  });
});

export default reducer;
