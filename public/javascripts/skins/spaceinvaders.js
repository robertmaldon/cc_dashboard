(function($) {

    $(document).ready(function() {

        function randomIntBetween(lower, higher) {
            return parseInt(rand_no = Math.floor((higher - (lower - 1)) * Math.random()) + lower);
        }

        /* Only sometimes show a saucer */
        if (randomIntBetween(1, 10) > 7) {
            var saucer = $('<img/>').attr('id', 'saucer').attr('class', 'saucer').attr('src', '../../images/skins/spaceinvaders/saucer.gif');
            $('#main').append(saucer);
            $('#saucer').animate({
                             left: '+='.concat($(window).width() - 50)
                         },
                         {
                             duration: 8000,
                             easing:   'linear',
                             queue:    false,
                             complete: function() { $('#saucer').hide(); }
                         });
        }

        function showAlien(index, src, top) {
            var alienLeftStart = $(window).width() / 4;
            var alienLeftEnd   = $(window).width() / 3;

            for (i = randomIntBetween(1, 5); i > 0; i--) {
                var alien = $('<img/>').attr('id', 'alien' + (index + i)).attr('class', 'alien').attr('src', '../../images/skins/spaceinvaders/' + src);
                $('#main').append(alien);
                var alienId = '#alien' + (index + i);
                $(alienId).css('top', top + 'px').css('left', alienLeftStart + (i * 70) + 'px');
                $(alienId).animate({
                                 left: '+=' + alienLeftEnd + 'px'
                             },
                             {
                                 duration: 12000,
                                 easing:   'linear',
                                 queue:    false,
                                 complete: function() { $(this).hide(); }
                             });
            }
        }

        var alienTop = $(window).height() / 3;

        showAlien(0,  'alien-top.gif',    alienTop);
        showAlien(10, 'alien-middle.gif', alienTop + 50);
        showAlien(20, 'alien-bottom.gif', alienTop + 100);

    });

})(jQuery);
