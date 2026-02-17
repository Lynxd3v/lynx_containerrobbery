window.addEventListener('message', function (event) {
    const e = event.data

    if (e.action === 'open') {
        RenderContainers(e.list)
        $('.container').fadeIn(400)
        $('#xp-value').text(e.xp)
    } else if (e.action === 'close') {
        $('.container').fadeOut(400)
    }
})

function RenderContainers(list) {
    $('.container-content').empty()
    list.forEach(element => {
        $div = $(
            `<div class="rcontainer">
                    <div class="rcontainer-content" id="container-${element.id}">
                        <div class="rcontainer-background"></div>
                        
                        <h2>${element.name}</h2>
                        <p>Mennyi container: ${element.count}</p>
                        <p>Küldetés nehézsége: ${element.difficulty}</p>
                        <p>Követelmény: ${element.xp}XP</p>

                        <button onclick="StartQuest(${element.id})" id="button-${element.id}">Küldetés felvétele</button>
                    </div>
                </div>
                `
        )
        $('.container-content').append($div)
    });
}

function StartQuest(id) {
    if ($(`#container-${id}`).text() === 'Küldetés felvétele') {
        $.post('http://lynx_containerrobbery/StartQuest', JSON.stringify({
            id: id
        }), function (data) {
            if (data.success) {
                alert(data.message)
                text = 'Küldetés megszakítása'
                $(`#container-${id}`).text(text)
                $(`#button-${id}`).css('background-color', 'red')
            }
        })
    } else if ($(`#container-${id}`).text() === 'Küldetés megszakítása') {
        $.post('http://lynx_containerrobbery/BreakingQuest', JSON.stringify({
            id:id
        }), function (data) {
            if (data.success) {
                alert(data.message)
                text = 'Küldetés felvétele'
                $(`#container-${id}`).text(text)
                $(`#button-${id}`).css('background-color', 'rgb(83, 83, 83)')
            }
        })
    }
}

    $(window).on('keyup', function (e) {
        if (e.key === 'Escape') {
            $.post('http://lynx_containerrobbery/ClosePanel')
        }
    })