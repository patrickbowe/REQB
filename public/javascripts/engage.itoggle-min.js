/*---------------
 * jQuery iToggle Plugin by Engage Interactive
 * Examples and documentation at: http://labs.engageinteractive.co.uk/itoggle/
 * Copyright (c) 2009 Engage Interactive
 * Version: 1.0 (10-JUN-2009)
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 * Requires: jQuery v1.3 or later
 ---------------*/

(function($) {
    $.fn.iToggle = function(options) {
        clickEnabled = true;
        var defaults = {type:'checkbox',keepLabel:true,easing:false,speed:200,onClick:function() {
        },onClickOn:function() {
        },onClickOff:function() {
        },onSlide:function() {
        },onSlideOn:function() {
        },onSlideOff:function() {
        }},settings = $.extend({}, defaults, options);



        $('label.itoggle').click(function() {
            if (clickEnabled == true) {
                clickEnabled = false;
                if ($(this).hasClass('iT_radio')) {
                    if ($(this).hasClass('iTon')) {
                        clickEnabled = true;
                    } else {
                        slide($(this), true);
                    }
                } else {
                    slide($(this));
                }
            }
            return false;
        });

        function slide($object, radio) {

            settings.onClick.call($object);
            h = $object.innerHeight();
            t = $object.attr('for');
            if ($object.hasClass('iTon')) {
                settings.onClickOff.call($object);
                $object.animate({backgroundPosition:'100% -' + h + 'px'}, settings.speed, settings.easing, function() {


               model_name=$('form[id*=edit_]').attr("id").split("_")[1];
                  id= $('form[id*=edit_'+model_name+'_]').attr("id").split("_")[2] ;
                    cl_name= $(this).attr("id")  ;
                    $.ajax({url:"/homes/on_off?id="+ id+ "&cl_name="+cl_name+"&off=f"+"&model_name="+model_name });

                   //alert("going to off");
                 // $.ajax({url:"/homes/on_off?id="+ id+ "&cl_name="+cl_name+"&off=off" });

                    $object.removeClass('iTon').addClass('iToff');
                    clickEnabled = true;
                    settings.onSlide.call(this);
                    settings.onSlideOff.call(this);
                });
                $('input#' + t).removeAttr('checked');

            }
            else {
                settings.onClickOn.call($object);
                $object.animate({backgroundPosition:'0% -' + h + 'px'}, settings.speed, settings.easing, function() {

                 model_name=$('form[id*=edit_]').attr("id").split("_")[1] ;
                  id= $('form[id*=edit_'+model_name+'_]').attr("id").split("_")[2]  ;
                   cl_name= $(this).attr("id");
                    $.ajax({url:"/homes/on_off?id="+ id+ "&cl_name="+cl_name+"&off=t"+"&model_name="+model_name });


                  // $.ajax({url:"/homes/on_off?id="+ id+ "&cl_name="+cl_name+"&off=on" });
                    //alert("going to on");

                    $object.removeClass('iToff').addClass('iTon');
                    clickEnabled = true;
                    settings.onSlide.call(this);
                    settings.onSlideOn.call(this);
                });
                $('input#' + t).attr('checked', 'checked');
            }
            if (radio == true) {
                name = $('#' + t).attr('name');
                slide($object.siblings('label[for]'));
            }
        }
    };
})(jQuery);