module.exports =
class Navigation

  constructor: (size) ->
    @historyPrev = []
    @historyCurr = null
    @historyNext = []
    @historyMax = size

  save: (model) ->

    if not @historyCurr?
      @pushCurrentToHistoryPrev()
    else
      if @historyCurr.keyword?
        if @historyCurr.keyword isnt model.functionName
          @historyPrevPush @historyCurr
          @pushCurrentToHistoryPrev()
      else
        @pushCurrentToHistoryPrev()

    @historyCurr =
      path: model.projectDir
      pos:
        column: 0
        row: model.lineNumber - 1
      keyword: model.functionName

    @historyNext = []

  pushCurrentToHistoryPrev: ->
    editor = atom.workspace.getActiveTextEditor()
    pos = editor?.getCursorBufferPosition()
    file = editor?.buffer.file
    filePath = file?.path
    if pos? and filePath?
      @historyPrevPush
        path: filePath
        pos: pos
        keyword: null

  historyPrevPush: (item) ->
    @historyPrev.push item
    if @historyPrev.length > @historyMax
      @historyPrev.shift()

  openHistoryCurr: ->
    atom.workspace.open(@historyCurr.path, {initialLine: @historyCurr.pos.row, initialColumn: @historyCurr.pos.column})

  openNext: ->
    next = @historyNext.pop()
    return if not next?
    @historyPrev.push @historyCurr if @historyCurr?
    @historyCurr = next
    @openHistoryCurr()

  openPrev: ->
    prev = @historyPrev.pop()
    return if not prev?
    @historyNext.push @historyCurr if @historyCurr?
    @historyCurr = prev
    @openHistoryCurr()
