$(function() {

    const overSound = document.getElementById('overSound');
    
    $('.item').on('mouseenter', function() {
        // Reproducir el sonido al pasar el ratón por encima del elemento
        overSound.currentTime = 0;
        overSound.play();
    });
    $('.item-foto').on('mouseenter', function() {
        // Reproducir el sonido al pasar el ratón por encima del elemento
        overSound.currentTime = 0;
        overSound.play();
    });
    $('.item-menu').on('mouseenter', function() {
        // Reproducir el sonido al pasar el ratón por encima del elemento
        overSound.currentTime = 0;
        overSound.play();
    });

    window.addEventListener( 'message', function( event ) {
        var item = event.data;
        
        switch (item.action) {
            case 'show':
                $('.container').fadeIn(500);
            break;

            case 'hide':
                $('.container').fadeOut(500);
                
                const myTooltipEl = document.querySelectorAll('.myTooltip');
        
                myTooltipEl.forEach(myTool => {
                    const tooltip = bootstrap.Tooltip.getOrCreateInstance(myTool)
                    tooltip.hide()
                })
            break;
        };
    });

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
        };
    }

    // MENU
    $('.item-menu').on('click', function() {
        if ($(this).hasClass('active')) {
            $(this).removeClass('active');
        } else {
            $(this).addClass('active');
        };

        $.post(`https://${GetParentResourceName()}/select`, JSON.stringify({
            item: this.id
        }));
    });

    $('.option').on('click', function() {
        $.post(`https://${GetParentResourceName()}/reset`);

        $('.item-menu').removeClass('active');
    })

    $('.reset').on('click', function() {
        $.post(`https://${GetParentResourceName()}/reset`);

        $('.item-menu').removeClass('active');
    })







    $('.item').on('click', function() {
        if ($(this).hasClass('active')) {
            $(this).removeClass('active');
        } else {
            $(this).addClass('active');
        };

        $.post(`https://${GetParentResourceName()}/select`, JSON.stringify({
            item: this.id
        }));
    });

    $('.item-foto').on('click', function() {
        if ($(this).hasClass('active')) {
            $(this).removeClass('active');
        } else {
            $(this).addClass('active');
        };

        $.post(`https://${GetParentResourceName()}/select`, JSON.stringify({
            item: this.id
        }));
    });

    // $('.item').on('mouseenter', function () {
    //     s_over.currentTime = '0';
    //     s_over.play();
    // });

    $('.option').on('click', function() {
        $.post(`https://${GetParentResourceName()}/reset`);

        $('.item').removeClass('active');
    })

    $('.reset').on('click', function() {
        $.post(`https://${GetParentResourceName()}/reset`);

        $('.item').removeClass('active');
    })

    $('.option-foto').on('click', function() {
        $.post(`https://${GetParentResourceName()}/reset`);

        $('.item-foto').removeClass('active');
    })

    $('.reset-foto').on('click', function() {
        $.post(`https://${GetParentResourceName()}/reset`);

        $('.item-foto').removeClass('active');
    })

    const myTooltipEl = document.querySelectorAll('.myTooltip');
        
    myTooltipEl.forEach(myTool => {
        const tooltip = bootstrap.Tooltip.getOrCreateInstance(myTool)

        myTool.addEventListener('hidden.bs.tooltip', () => {
  
        })

        tooltip.hide()
    })
});
