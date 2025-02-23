/// The functions are simply used to facilitate communication between
/// Flutter and the native implementations.

/// To acquire a deeper understanding of how events are handled, look at the
/// native implementations.
part of pdftron;

const _exportAnnotationCommandChannel =
    const EventChannel('export_annotation_command_event');
const _exportBookmarkChannel = const EventChannel('export_bookmark_event');
const _documentLoadedChannel = const EventChannel('document_loaded_event');
const _documentErrorChannel = const EventChannel('document_error_event');
const _annotationChangedChannel =
    const EventChannel('annotation_changed_event');
const _annotationsSelectedChannel =
    const EventChannel('annotations_selected_event');
const _formFieldValueChangedChannel =
    const EventChannel('form_field_value_changed_event');
const _behaviorActivatedChannel =
    const EventChannel('behavior_activated_event');
const _longPressMenuPressedChannel =
    const EventChannel('long_press_menu_pressed_event');
const _annotationMenuPressedChannel =
    const EventChannel('annotation_menu_pressed_event');
const _leadingNavButtonPressedChannel =
    const EventChannel('leading_nav_button_pressed_event');
const _pageChangedChannel = const EventChannel('page_changed_event');
const _zoomChangedChannel = const EventChannel('zoom_changed_event');
const _pageMovedChannel = const EventChannel('page_moved_event');

typedef void ExportAnnotationCommandListener(dynamic xfdfCommand);
typedef void ExportBookmarkListener(dynamic bookmarkJson);
typedef void DocumentLoadedListener(dynamic filePath);
typedef void DocumentErrorListener();
typedef void AnnotationChangedListener(dynamic action, dynamic annotations);
typedef void AnnotationsSelectedListener(dynamic annotationWithRects);
typedef void FormFieldValueChangedListener(dynamic fields);
typedef void BehaviorActivatedListener(dynamic action, dynamic data);
typedef void LongPressMenuPressedChannelListener(
    dynamic longPressMenuItem, dynamic longPressText);
typedef void AnnotationMenuPressedChannelListener(
    dynamic annotationMenuItem, dynamic annotations);
typedef void LeadingNavbuttonPressedlistener();
typedef void PageChangedListener(
    dynamic previousPageNumber, dynamic pageNumber);
typedef void ZoomChangedListener(dynamic zoom);
typedef void PageMovedListener(dynamic previousPageNumber, dynamic pageNumber);
typedef void CancelListener();

/// Used to identify listeners for the EventChannel.
enum eventSinkId {
  exportAnnotationId,
  exportBookmarkId,
  documentLoadedId,
  documentErrorId,
  annotationChangedId,
  annotationsSelectedId,
  formFieldValueChangedId,
  behaviorActivatedId,
  longPressMenuPressedId,
  annotationMenuPressedId,
  leadingNavButtonPressedId,
  pageChangedId,
  zoomChangedId,
  pageMovedId,
}

/// Listens for when a local annotation changes have been committed to the document.
///
/// Returns a function that can cancel the listener.
CancelListener startExportAnnotationCommandListener(
    ExportAnnotationCommandListener listener) {
  var subscription = _exportAnnotationCommandChannel
      .receiveBroadcastStream(eventSinkId.exportAnnotationId.index)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for when user bookmarks are committed to the document.
///
/// Returns a function that can cancel the listener.
CancelListener startExportBookmarkListener(ExportBookmarkListener listener) {
  var subscription = _exportBookmarkChannel
      .receiveBroadcastStream(eventSinkId.exportBookmarkId.index)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for when [PdftronFlutter.openDocument(document)] has loaded the file.
///
/// Returns a function that can cancel the listener.
CancelListener startDocumentLoadedListener(DocumentLoadedListener listener) {
  var subscription = _documentLoadedChannel
      .receiveBroadcastStream(eventSinkId.documentLoadedId.index)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for errors that could occur when [PdftronFlutter.openDocument(document)] is called.
///
/// Returns a function that can cancel the listener.
CancelListener startDocumentErrorListener(DocumentErrorListener listener) {
  var subscription = _documentErrorChannel
      .receiveBroadcastStream(eventSinkId.documentErrorId.index)
      .listen((stub) {
    listener();
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for annotation changes and gets the associated action.
///
/// Returns a function that can cancel the listener.
CancelListener startAnnotationChangedListener(
    AnnotationChangedListener listener) {
  var subscription = _annotationChangedChannel
      .receiveBroadcastStream(eventSinkId.annotationChangedId.index)
      .listen((annotationsWithActionString) {
    dynamic annotationsWithAction = jsonDecode(annotationsWithActionString);
    String action = annotationsWithAction[EventParameters.action];
    List<dynamic> annotations = Platform.isIOS
        ? jsonDecode(annotationsWithAction[EventParameters.annotations])
        : annotationsWithAction[EventParameters.annotations];
    List<Annot> annotList = new List<Annot>.empty(growable: true);
    for (dynamic annotation in annotations) {
      annotList.add(new Annot.fromJson(annotation));
    }
    listener(action, annotList);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for when an annotation is selected.
///
/// Returns a function that can cancel the listener.
CancelListener startAnnotationsSelectedListener(
    AnnotationsSelectedListener listener) {
  var subscription = _annotationsSelectedChannel
      .receiveBroadcastStream(eventSinkId.annotationsSelectedId.index)
      .listen((annotationWithRectsString) {
    List<dynamic> annotationWithRects = jsonDecode(annotationWithRectsString);
    List<AnnotWithRect> annotWithRectList =
        new List<AnnotWithRect>.empty(growable: true);
    for (dynamic annotationWithRect in annotationWithRects) {
      annotWithRectList.add(new AnnotWithRect.fromJson(annotationWithRect));
    }
    listener(annotWithRectList);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for changes to the value of form fields.
///
/// Returns a function that can cancel the listener.
CancelListener startFormFieldValueChangedListener(
    FormFieldValueChangedListener listener) {
  var subscription = _formFieldValueChangedChannel
      .receiveBroadcastStream(eventSinkId.formFieldValueChangedId.index)
      .listen((fieldsString) {
    List<dynamic> fields = jsonDecode(fieldsString);
    List<Field> fieldList = new List<Field>.empty(growable: true);
    for (dynamic field in fields) {
      fieldList.add(new Field.fromJson(field));
    }
    listener(fieldList);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for start of certain behaviours, if [Config.overrideBehavior] is not null.
///
/// Returns a function that can cancel the listener.
CancelListener startBehaviorActivatedListener(
    BehaviorActivatedListener listener) {
  var subscription = _behaviorActivatedChannel
      .receiveBroadcastStream(eventSinkId.behaviorActivatedId.index)
      .listen((behaviorString) {
    dynamic behaviorObject = jsonDecode(behaviorString);
    dynamic action = behaviorObject[EventParameters.action];
    dynamic data = behaviorObject[EventParameters.data];
    listener(action, data);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for presses on the long press menu,
/// if [Config.overrideLongPressMenuBehavior] is not null.
///
/// Returns a function that can cancel the listener.
CancelListener startLongPressMenuPressedListener(
    LongPressMenuPressedChannelListener listener) {
  var subscription = _longPressMenuPressedChannel
      .receiveBroadcastStream(eventSinkId.longPressMenuPressedId.index)
      .listen((longPressString) {
    dynamic longPressObject = jsonDecode(longPressString);
    dynamic longPressMenuItem =
        longPressObject[EventParameters.longPressMenuItem];
    dynamic longPressText = longPressObject[EventParameters.longPressText];
    listener(longPressMenuItem, longPressText);
  }, cancelOnError: true);
  return () {
    subscription.cancel();
  };
}

/// Listens for presses on the annotation menu,
/// if [Config.overrideAnnotationMenuBehavior] is not null.
///
/// Returns a function that can cancel the listener.
CancelListener startAnnotationMenuPressedListener(
    AnnotationMenuPressedChannelListener listener) {
  var subscription = _annotationMenuPressedChannel
      .receiveBroadcastStream(eventSinkId.annotationMenuPressedId.index)
      .listen((annotationMenuString) {
    dynamic annotationMenuObject = jsonDecode(annotationMenuString);
    dynamic annotationMenuItem =
        annotationMenuObject[EventParameters.annotationMenuItem];
    dynamic annotations = annotationMenuObject[EventParameters.annotations];
    List<Annot> annotList = new List<Annot>.empty(growable: true);
    for (dynamic annotation in annotations) {
      annotList.add(Annot.fromJson(annotation));
    }
    listener(annotationMenuItem, annotList);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for when the leading navigation button is pressed.
///
/// Returns a function that can cancel the listener.
CancelListener startLeadingNavButtonPressedListener(
    LeadingNavbuttonPressedlistener listener) {
  var subscription = _leadingNavButtonPressedChannel
      .receiveBroadcastStream(eventSinkId.leadingNavButtonPressedId.index)
      .listen((stub) {
    listener();
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for when a page is changed in the viewer.
///
/// Returns a function that can cancel the listener.
CancelListener startPageChangedListener(PageChangedListener listener) {
  var subscription = _pageChangedChannel
      .receiveBroadcastStream(eventSinkId.pageChangedId.index)
      .listen((pagesString) {
    dynamic pagesObject = jsonDecode(pagesString);
    dynamic previousPageNumber =
        pagesObject[EventParameters.previousPageNumber];
    dynamic pageNumber = pagesObject[EventParameters.pageNumber];
    listener(previousPageNumber, pageNumber);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for if the document's zoom ratio is changed.
///
/// Returns a function that can cancel the listener.
CancelListener startZoomChangedListener(ZoomChangedListener listener) {
  var subscription = _zoomChangedChannel
      .receiveBroadcastStream(eventSinkId.zoomChangedId.index)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startPageMovedListener(PageMovedListener listener) {
  var subscription = _pageMovedChannel
      .receiveBroadcastStream(eventSinkId.pageMovedId.index)
      .listen((pagesString) {
    dynamic pagesObject = jsonDecode(pagesString);
    dynamic previousPageNumber =
        pagesObject[EventParameters.previousPageNumber];
    dynamic pageNumber = pagesObject[EventParameters.pageNumber];
    listener(previousPageNumber, pageNumber);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}
