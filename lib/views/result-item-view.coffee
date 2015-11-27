{View} = require 'space-pen'

module.exports =
class ResultItemView extends View
  @content: ->
    @li class: 'result-item',  =>
      @span class: 'file-name'
      @div class: 'inline-block', outlet: 'fileDetails', =>
        @span ":"
        @span class: 'line-number bold'
        @span class: 'gap'
        @span class: 'highlight function-name'
        @span class: 'gap'
        @div class: 'inline-block code-line', =>
      
  @setup: (result, keyword) ->
    resultItem = new @
    item = resultItem.containingView()
    item.data('result-item', result)
    if !result.isJustFile
      item.find('.file-name').text(result.fileName)
      item.find('.line-number').text(result.lineNumber)
      item.find('.function-name').text(result.functionName)
      item.find('.code-line').html(result.lineText)
    else
      item.find('.file-name').html(result.fileName)
      resultItem.fileDetails.remove()
      
    return resultItem
    
  getResultItem: ->
    @containingView().data('result-item')