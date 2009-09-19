var ArticleForm = {
  saveDraft: function() {
    var isDraft = $F(this);
    if(isDraft) ['publish-date-lbl', 'publish-date'].each(Element.hide);
    else ['publish-date-lbl', 'publish-date'].each(Element.show);
  }
}

Event.addBehavior({
  '#article-draft':  function() { Event.observe(this, 'change', ArticleForm.saveDraft.bind(this)); },
});