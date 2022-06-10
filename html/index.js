// ----------------------------------------------------------------
// --  _      _    _             _   _               _         _ --
// -- | |    / \  | |__   ___   | \ | |_ __ ___  ___| |__     | |--
// -- | |   / _ \ | '_ \ / _ \  |  \| | '_ ` _ \/ __| '_ \    | |--
// -- |_|_ / ___ \| |_) | (_) | | |\  | | | | | \__ \ | | |_ _|_|--
// -- (_|_)_/   \_\_.__/ \___/  |_| \_|_| |_| |_|___/_| |_(_|_|_)--
// -- https://discord.gg/rfEs2VvaSd                              --
// ----------------------------------------------------------------

$(document).ready(function(){
    $(".container").hide();
    $(".info-box").hide();
    var current
    var pos
    var lastpos

    window.addEventListener("message", function(event){
        var data = event.data
        var Jail111 = data.Jail
        var InJail1 = data.InJail
        lastpos = data.lastpos
        $(".container").show()
        createButtons(data.data, Jail111 || null, InJail1)
    });
    

    // Function
    function createButtons(data, Jail, InJail1) { 
        var len = data?.length;
        var len1 = data[0].length;
        console.log(Jail, InJail1);
        for (i = 0; i < len; i++) {
            $(".spawn-points").append('<i class="fas fa-map-marker-alt" data-id=' + i + ' id="loc' + i + '"><div class="info-box" id="label' + i +'">' + data[i].label + '</div></i>');
            $(".spawn-points").find("[data-id="+i+"]").data("data", data[i]);
            $(".spawn-points").find("[data-id="+i+"]").data("coords", data[i].coords);
            $(".spawn-points").find("[data-id="+i+"]").data("id", i);
        }
    }


    function refresh(){
        window.location.reload("")
    }


    // İconlar
    $(document).on("mouseenter", ".fas", function(e){
        var th = $(this)
        $("#label"+th.data("id")).fadeIn(150);
        if (th.data("data").label != null) {
            $("#label"+current).fadeOut(150);
        }
    });

    $(document).on("mouseleave", ".fas", function(e){
        var th = $(this)
        if ("#label" + th.data("id") != "#label"+current) {
            $("#label"+th.data("id")).fadeOut(150);
        }
    });

    $(document).on("click", ".fas", function(e){
        var th = $(this)
        if (current != null) {
            $("#loc"+current).css("color", "rgb(255, 65, 65)");
            $("#loc"+current).css("font-size", "x-large");
            $("#label"+current).fadeOut(400);
        }
       $("#loc"+th.data("id")).css("color", "rgb(253, 253, 253)");
       current = th.data("id")
       pos = th.data("coords")
    });



    // Butonlar
    $(document).on("click", ".fa-map-marker-alt", function(e){
        if (pos != null) {
            $(".container").fadeOut(500)
            $.post('https://nmsh-spawn-selector/spawn', JSON.stringify({coords: pos}));
            $('#info').hide()
            refresh()
        }
    });

    $(document).on("click", ".lastspawn", function(e){
        $(".container").fadeOut(500)
        $.post('https://nmsh-spawn-selector/loadplayer', JSON.stringify({coords: pos}));
        $('#info').hide()
        refresh()
    });
})

// ----------------------------------------------------------------
// --  _      _    _             _   _               _         _ --
// -- | |    / \  | |__   ___   | \ | |_ __ ___  ___| |__     | |--
// -- | |   / _ \ | '_ \ / _ \  |  \| | '_ ` _ \/ __| '_ \    | |--
// -- |_|_ / ___ \| |_) | (_) | | |\  | | | | | \__ \ | | |_ _|_|--
// -- (_|_)_/   \_\_.__/ \___/  |_| \_|_| |_| |_|___/_| |_(_|_|_)--
// -- https://discord.gg/rfEs2VvaSd                              --
// ----------------------------------------------------------------