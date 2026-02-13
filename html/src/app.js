window.addEventListener('message',function (event) {
    const e = event.data

    if (e.action === 'open') {
        RenderContainers(e.list)
        $('.container').fadeIn(400)
    } else if (e.action === 'close') {

    }
})

function RenderContainers(list) {
    list.forEach(element => {
        
    });
}