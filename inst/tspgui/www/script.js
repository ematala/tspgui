shinyjs.jumpToElement = function(elementId) {
    document.getElementById(elementId).scrollIntoView();
    window.scrollBy(0, -50);
}
shinyjs.jumpToTop = function() { window.scrollTo(0, 0); }