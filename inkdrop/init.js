inkdrop.menu.add([
  {
    label: "File",
    submenu: [
      {
        label: "Templates",
        submenu: [
          {
            label: "Create a journal",
            command: "custom:new-journal",
          },
          {
            label: "Create article",
            command: "custom:new-article",
          },
          {
            label: "Create a task",
            command: "custom:new-task",
          },
        ],
      },
    ],
  },
]);

inkdrop.commands.add(document.body, "custom:new-journal", async () => {
  const db = inkdrop.main.dataStore.getLocalDB();
  const template = await db.notes.get("note:CJxgtFLd7");
  const note = {
    ...template,
    _id: db.notes.createId(),
    _rev: undefined,
    title: new Date().toLocaleDateString(),
    createdAt: +new Date(),
    updatedAt: +new Date(),
    pinned: false,
  };
  try {
    await db.notes.put(note);
    inkdrop.commands.dispatch(document.body, "core:open-note", {
      noteId: note._id,
    });
    inkdrop.commands.dispatch(document.body, "editor:focus-mde");
  } catch (e) {
    console.error(e);
  }
});

inkdrop.commands.add(document.body, "custom:new-task", async () => {
  const db = inkdrop.main.dataStore.getLocalDB();
  const template = await db.notes.get("note:YF-zo9WLO"); // [task template](inkdrop://note/PSS7Csy28)
  const note = {
    ...template,
    _id: db.notes.createId(),
    _rev: undefined,
    title: "Task ::",
    createdAt: +new Date(),
    updatedAt: +new Date(),
    pinned: false,
  };
  try {
    await db.notes.put(note);
    inkdrop.commands.dispatch(document.body, "core:open-note", {
      noteId: note._id,
    });
    inkdrop.commands.dispatch(document.body, "editor:focus-mde");
  } catch (e) {
    console.error(e);
  }
});

inkdrop.commands.add(document.body, "custom:new-article", async () => {
  const db = inkdrop.main.dataStore.getLocalDB();
  const template = await db.notes.get("note:aZ6rlu7wD");
  const note = {
    ...template,
    _id: db.notes.createId(),
    _rev: undefined,
    title: new Date().toLocaleDateString() + ": ",
    createdAt: +new Date(),
    updatedAt: +new Date(),
    pinned: false,
  };
  try {
    await db.notes.put(note);
    inkdrop.commands.dispatch(document.body, "core:open-note", {
      noteId: note._id,
    });
    inkdrop.commands.dispatch(document.body, "editor:focus-mde");
  } catch (e) {
    console.error(e);
  }
});
