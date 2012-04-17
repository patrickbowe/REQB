// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
    date= new Date();
    var flag_def = "false"
    var flag_basic = "false"
    var flag_alter = "false"
    var flag_req_use = "false"
    var flag_tracker_use = "false"
    var flag_req_tracker = "false"
    var flag_req_file = "false"
    var flag_use_file = "false"
    var flag_req_tracker = "false"
    var text_value1="preserve_value"
    var text_value2="preserve_value"
    var flag_val="false"
    var ajaxLoading = function() {
        $("span#loading").toggle();
        $("span#loading1").toggle();
    };

    //$('.mySelectBoxClass').customStyle();
   // $('#payment_type_').attr('disabled', true)
    //$('#plan_type_').attr('disabled', true)
    $('#dismiss_flag').click(function()
    {
        if ($(this).attr('checked'))
        {
            jQuery.ajax({url:'/homes/set_dismiss_dashboard_flag/' + true,success :function(data) {

            }})
        }

    });

    /* For submit payment form */
    $('#payment_submit1').click(function(e)
    {
        flag_val="true";
        var flag = false;
        if (($('#first_name').attr("value") == "") || ($('#first_name').attr("value").length < 2))
        {
            //$('#first_name').focus();
            $("#first_name_error").html("").append("First name must contain at least two characters")
            $('#first_name_error').css({'color':'red'});
            flag = true;
            flag_val="false";
        }
        if (($('#last_name').attr("value") == "") || ($('#last_name').attr("value").length < 2))
        {
            //$('#last_name').focus();
            $("#last_name_error").html("").append("Last name must contain at least two characters")
            $('#last_name_error').css({'color':'red'});
            flag = true;
             flag_val="false";
        }

        if (($('#subdomain').attr("value") == ""))
        {
            //$('#first_name').focus();
            $("#subdomain_error").html("").append("Sub domain should be unique.")
            $('#subdomain_error').css({'color':'red'});
            flag = true;
             flag_val="false";
        }
        else
        {
            //alert("hi");
            var subdomain = $("#subdomain").val();

            $.ajax({url: '/users/check_domain/' + subdomain,success:function(data) {
                                   var obj = $.parseJSON(data);
                                   if (obj==true)
                                   {
                                    flag=true;  
                                     $("#subdomain_error").html("").append("Sub domain should be unique.")
                                     $('#subdomain_error').css({'color':'red'});
                                      flag_val="false";

                                   }
            }});

        }

        if (($('#address').attr("value") == "") || ($('#address').attr("value").length < 2))
        {
            //$('#address').focus();

            $("#address_error").html("").append("Billing Address must contain at least two characters")
            $('#address_error').css({'color':'red'});
            flag = true;
             flag_val="false";
        }
        if (($('#city').attr("value") == "") || ($('#city').attr("value").length < 2))
        {

            $("#city_error").html("").append("City must contain at least two characters")
            $('#city_error').css({'color':'red'});
            //$('#city').focus();
            flag = true;
             flag_val="false";

        }
        if (($('#zip').attr("value") == "") || ($('#zip').attr("value").length < 2))
        {
            //$('#zip').focus();

            $("#zip_error").html("").append("Zip must contain at least two characters")
            $('#zip_error').css({'color':'red'});
            flag = true;
             flag_val="false";
        }
        //else  if ($('#region').attr("value")=="")
        //{
        //  alert("Please enter region / province");
        //$('#region').focus();
        //e.preventDefault();
        // }
        if ($("select#country_ option:selected").text() == "--Select--")
        {

            $("#country_error").html("").append("You must select a country from the list")
            $('#country_error').css({'color':'red'});
            //$('#country_').focus();
            flag = true;
             flag_val="false";
        }
        if ($("#payment_type_ option:selected").text() == "--Select--")
        {
            $("#payment_type_error").html("").append("You must select a Payment Type from the list")
            $('#payment_type_error').css({'color':'red'});

            flag = true;
             flag_val="false";
        }


        if((!$('#accept_check').attr('checked')))
        {
            $("#accept_check_error").html("").append("You must have to accept")
            $('#accept_check_error').css({'color':'red'});
            flag = true;
            flag_val="false";
        }

        if (flag == true)
        {    flag_val="false";
            e.preventDefault();
        }
        else
        {

            var subdomain = $("#subdomain").val();

            $.ajax({url: '/users/check_domain/' + subdomain,success:function(data) {
                                   var obj = $.parseJSON(data);
                                   if (obj==true)
                                   {
                                     e.preventDefault();  
                                     $("#subdomain_error").html("").append("Sub domain should be unique.")
                                     $('#subdomain_error').css({'color':'red'});
                                       flag_val="false";

                                   }
                                   else
                                   {
                                       //$("#payment_submit").attr('style','display');
                                       $("#payment_submit").click();
                                   }
            }});




        }
    });

    /* For select project from project list */
    $("#project_name_project_id").change(function() {
        var project_id = $('select#project_name_project_id option:selected').val();
        //alert(project_name);
        jQuery.ajax({url:'/projects/update_project_name/' + project_id, success :function(data) {

        }})


    });

    /* Enter a requirement when user presses enter,tab or away  */
    $('#req_name').click(function(e)
    {
        if ($('#req_name').attr("value") == "<< Add requirement")
        {
            $(this).attr("value", "");
            $('#req_name').removeClass("inpTxt_ad rgt w400px");
            $('#req_name').addClass("inpTxt_ad lft w400px");
            $('#req_name').focus();
            e.preventDefault();

        }


    });


    $('#req_name').focusout(function(e)
    {
        if ($('#req_name').attr("value") != "<< Add requirement" && $('#req_name').attr("value")!="")
        {
            var req_name = jQuery.makeArray($('#req_name').attr("value"))
            $("#loading").show();
            jQuery.ajax({url:'/requirements/create?req_name=' + req_name,success :function(data) {

            },error: hideLoadingImage,complete: hideLoadingImage})

        }
    });

    function hideLoadingImage() {

        $("#loading").hide();
        $("#loading1").hide();

    }


    $('#req_name').keypress(function(e)
    {
        if ($('#req_name').attr("value") != "<< Add requirement"&& $('#req_name').attr("value")!="")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var req_name = jQuery.makeArray($('#req_name').attr("value"))
                $("#loading").show();
                jQuery.ajax({url:'/requirements/create?req_name=' + req_name, success :function(data) {

                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });

    /* Link a requirement with use case when user presses enter,tab or away  */
    $('#usecase_requirement').click(function(e)
    {
        if ($('#usecase_requirement').attr("value") == "<< Start typing to search for a requirement to link")
        {
            $(this).attr("value", "");
            $('#usecase_requirement').removeClass("inpTxt_ad rgt w450px");
            $('#usecase_requirement').addClass("inpTxt_ad lft w450px");

            $('#usecase_requirement').focus();
            e.preventDefault();

        }


    });

    $("#usecase_requirement").live('keyup', (function(e) {


        if ((e.which === 13) || (e.which === 9))
        {
            $('#match_req_usecase').hide();
        }
        else
        {
            var match_char = $("#usecase_requirement").val();
            if (match_char != "") {
                $.ajax({
                    url:"/requirements/match_requirement_name/" + match_char,
                    success:function(data) {
                        var obj = $.parseJSON(data);
                        var testSuggest = '';
                        testSuggest += '<ul>';
                        for (key in obj) {
                            testSuggest += '<li>' + obj[key].requirement.name + '</li>';
                        }
                        testSuggest += '</ul>';
                        $('#match_req_usecase').html(testSuggest);
                    }
                });
            }
            $('#match_req_usecase').show();
        }
    }));


    $('#match_req_usecase ul li').live('click', function(e) {
        $('#usecase_requirement').focus();
        $("#usecase_requirement").val($(this).text());
        $('#match_req_usecase').hide();
        flag_req_use = "true"
    });

    $('#usecase_requirement').focusout(function(e)
    {

        if ($('#usecase_requirement').attr("value") != "<< Start typing to search for a requirement to link")
        {
            var requirement = jQuery.makeArray($('#usecase_requirement').attr("value"));

            if (flag_req_use == "true" && requirement != "")
            {
                $("#loading").show();
                jQuery.ajax({url:'/requirements/create_requirement_use?requirement=' + requirement, success :function(data) {
                    flag_req_use = "false"
                },error: hideLoadingImage,complete: hideLoadingImage})
            }
        }
    });

    $('#usecase_requirement').keypress(function(e)
    {

        if ($('#usecase_requirement').attr("value") != "<< Start typing to search for a requirement to link" && $('#usecase_requirement').attr("value") !="")
        {

            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var requirement = jQuery.makeArray($('#usecase_requirement').attr("value"))
                $("#loading").show();
                jQuery.ajax({url:'/requirements/create_requirement_use?requirement=' + requirement, success :function(data) {

                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });

    /* Link a requirement with tracker when user presses enter,tab or away  */
    $('#tracker_requirement').click(function(e)
    {
        if ($('#tracker_requirement').attr("value") == "<< Start typing to search for a requirement to link")
        {
            $(this).attr("value", "");
            $('#tracker_requirement').removeClass("inpTxt_ad rgt w450px");
            $('#tracker_requirement').addClass("inpTxt_ad lft w450px");
            
            $('#tracker_requirement').focus();
            e.preventDefault();

        }


    });

    $("#tracker_requirement").live('keyup', (function(e) {


        if ((e.which === 13) || (e.which === 9))
        {
            $('#match_req_usecase').hide();
        }
        else
        {
            var match_char = $("#tracker_requirement").val();
            if (match_char != "") {
                $.ajax({
                    url:"/requirements/match_requirement_name/" + match_char,
                    success:function(data) {
                        var obj = $.parseJSON(data);
                        var testSuggest = '';
                        testSuggest += '<ul>';
                        for (key in obj) {
                            testSuggest += '<li>' + obj[key].requirement.name + '</li>';
                        }
                        testSuggest += '</ul>';
                        $('#match_req_usecase').html(testSuggest);
                    }
                });
            }
            $('#match_req_usecase').show();
        }
    }));


    $('#match_req_usecase ul li').live('click', function(e) {
        $('#tracker_requirement').focus();
        $("#tracker_requirement").val($(this).text());
        $('#match_req_usecase').hide();
        flag_req_tracker = "true"
    });

    $('#tracker_requirement').focusout(function(e)
    {

        if ($('#tracker_requirement').attr("value") != "<< Start typing to search for a requirement to link")
        {
            var requirement = jQuery.makeArray($('#tracker_requirement').attr("value"));

            if (flag_req_tracker == "true" && requirement != "")
            {
                $("#loading").show();
                jQuery.ajax({url:'/requirements/create_requirement_tracker?requirement=' + requirement, success :function(data) {
                    flag_req_tracker = "false"
                },error: hideLoadingImage,complete: hideLoadingImage})
            }
        }
    });

    $('#tracker_requirement').keypress(function(e)
    {

        if ($('#tracker_requirement').attr("value") != "<< Start typing to search for a requirement to link")
        {

            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var requirement = jQuery.makeArray($('#tracker_requirement').attr("value"))
                $("#loading").show();
                jQuery.ajax({url:'/requirements/create_requirement_tracker?requirement=' + requirement, success :function(data) {

                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });

    /* Enter an use case when user presses enter,tab or away  */
    $('#use_case_name').click(function(e)
    {
        if ($('#use_case_name').attr("value") == "<< Add use case")
        {
            $(this).attr("value", "");
            $('#use_case_name').removeClass("inpTxt_ad rgt w400px");
            $('#use_case_name').addClass("inpTxt_ad lft w400px");
            $('#use_case_name').focus();
            e.preventDefault();

        }


    });


    $('#use_case_name').focusout(function(e)
    {
        if ($('#use_case_name').attr("value")!="")
        {
          var use_name = jQuery.makeArray($('#use_case_name').attr("value"))
          $("#loading").show();
          jQuery.ajax({url:'/use_cases/create?use_case_name=' + use_name, success :function(data) {
          },error: hideLoadingImage,complete: hideLoadingImage})
        }

    });

    $('#use_case_name').keypress(function(e)
    {
        if (($('#use_case_name').attr("value") != "<< Add use case") && $('#use_case_name').attr("value")!="")
        {
            if (e.which === 13 || e.which === 9) { // if is enter
                var use_name = jQuery.makeArray($('#use_case_name').attr("value"))
                $("#loading").show();
                jQuery.ajax({url:'/use_cases/create?use_case_name=' + use_name, success :function(data) {

                    // window.location.reload()
                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });
    //Link an use case with requirement
    $('#req_use_case_name').live('click', (function(e)
    {
        if ($('#req_use_case_name').attr("value") == "<< Start typing to search for a use case to link")
        {
            $(this).attr("value", "");
            $('#req_use_case_name').removeClass("inpTxt_ad rgt w450px");
            $('#req_use_case_name').addClass("inpTxt_ad lft w450px");
            $('#req_use_case_name').focus();
            e.preventDefault();

        }


    }));

    $("#req_use_case_name").live('keyup', (function(e) {


        if ((e.which === 13) || (e.which === 9))
        {
            $('#match_req_usecase').hide();
        }
        else
        {
            var match_char = $("#req_use_case_name").val();
            if (match_char != "") {
                $.ajax({
                    url:"/use_cases/match_usecase_name/" + match_char,
                    success:function(data) {
                        var obj = $.parseJSON(data);
                        var testSuggest = '';
                        testSuggest += '<ul>';
                        for (key in obj) {
                            testSuggest += '<li>' + obj[key].use_case.name + '</li>';
                        }
                        testSuggest += '</ul>';
                        $('#match_req_usecase').html(testSuggest);
                    }
                });
            }
            $('#match_req_usecase').show();
        }
    }));


    $('#match_req_usecase ul li').live('click', function(e) {
        $('#req_use_case_name').focus();
        $("#req_use_case_name").val($(this).text());
        $('#match_req_usecase').hide();
        flag_req_use = "true"
    });

    $('#req_use_case_name').live('focusout', (function(e)
    {

        var use_name = jQuery.makeArray($('#req_use_case_name').attr("value"))
        if (use_name != "" && flag_req_use == "true")
        {
            flag_req_use == "false"
            $("#loading").show();
            jQuery.ajax({url:'/use_cases/req_create?use_case_name=' + use_name, success :function(data) {

            },error: hideLoadingImage,complete: hideLoadingImage})
        }
    }));


    $('#req_use_case_name').live('keypress', (function(e)
    {

        if ($('#req_use_case_name').attr("value") != "<< Start typing to search for a use case to link" && $('#req_use_case_name').attr("value")!="")
        {
            if (e.which === 13 || e.which === 9) { // if is enter

                var use_name = jQuery.makeArray($('#req_use_case_name').attr("value"))
                $('#match_req_usecase').hide();
                if (use_name != "")
                {
                    $("#loading").show();
                    jQuery.ajax({url:'/use_cases/req_create?use_case_name=' + use_name, success :function(data) {

                        // window.location.reload()
                    },error: hideLoadingImage,complete: hideLoadingImage})

                }
            }

        }
    }));
    //End Link an use case to requirement

    //Link an use case to tracker
    $('#tracker_use_case_name').live('click', (function(e)
    {
        if ($('#tracker_use_case_name').attr("value") == "<< Start typing to search for a use case to link")
        {
            $(this).attr("value", "");
            $('#tracker_use_case_name').removeClass("inpTxt_ad rgt w450px");
            $('#tracker_use_case_name').addClass("inpTxt_ad lft w450px");
            $('#tracker_use_case_name').focus();
            e.preventDefault();

        }


    }));

    $("#tracker_use_case_name").live('keyup', (function(e) {


        if ((e.which === 13) || (e.which === 9))
        {
            $('#match_req_usecase').hide();
        }
        else
        {
            var match_char = $("#tracker_use_case_name").val();
            if (match_char != "") {
                $.ajax({
                    url:"/use_cases/match_usecase_name/" + match_char,
                    success:function(data) {
                        var obj = $.parseJSON(data);
                        var testSuggest = '';
                        testSuggest += '<ul>';
                        for (key in obj) {
                            testSuggest += '<li>' + obj[key].use_case.name + '</li>';
                        }
                        testSuggest += '</ul>';
                        $('#match_req_usecase').html(testSuggest);
                    }
                });
            }
            $('#match_req_usecase').show();
        }
    }));


    $('#match_req_usecase ul li').live('click', function(e) {
        $('#tracker_use_case_name').focus();
        $("#tracker_use_case_name").val($(this).text());
        $('#match_req_usecase').hide();
        flag_tracker_use = "true"
    });

    $('#tracker_use_case_name').live('focusout', (function(e)
    {

        var use_name = jQuery.makeArray($('#tracker_use_case_name').attr("value"))
        if (use_name != "" && flag_tracker_use == "true")
        {
            flag_tracker_use == "false"
            $("#loading").show();
            jQuery.ajax({url:'/use_cases/tracker_create?use_case_name=' + use_name, success :function(data) {

            },error: hideLoadingImage,complete: hideLoadingImage})
        }
    }));


    $('#tracker_use_case_name').live('keypress', (function(e)
    {

        if ($('#tracker_use_case_name').attr("value") != "<< Start typing to search for a use case to link")
        {
            if (e.which === 13 || e.which === 9) { // if is enter

                var use_name = jQuery.makeArray($('#tracker_use_case_name').attr("value"))
                $('#match_req_usecase').hide();
                if (use_name != "")
                {
                    $("#loading").show();
                    jQuery.ajax({url:'/use_cases/tracker_create?use_case_name=' + use_name, success :function(data) {

                        // window.location.reload()
                    },error: hideLoadingImage,complete: hideLoadingImage})

                }
            }

        }
    }));
    //End Link an use case to tracker
    /* Create a project when user presses enter,tab or away  */
    $('#project_name1').click(function(e)
    {
        
        if ($('#project_name1').attr("value") == "<< Add a new project")
        {
            $('#project_name1').removeClass("inpTxt_ad rgt w400px");
            $('#project_name1').addClass("inpTxt_ad lft w400px");
            $('#project_name1').val('');
            $('#project_name1').focus();
            e.preventDefault();
        }


    });

    $('#project_name1').focusout(function(e)
    {
        var project_name = jQuery.makeArray($('#project_name1').attr("value"));
        if ($('#project_name1').attr("value") != "<< Add a new project" && $.trim(project_name)!="")
        {
        $("#loading").show();
        jQuery.ajax({url:'/projects/create?project_name=' + project_name, success :function(data) {

        },error: hideLoadingImage,complete: hideLoadingImage})
        }
    });

    $('#project_name1').keypress(function(e)
    {
        if ($('#project_name1').attr("value") != "<< Add a new project" && $.trim("#project_name1")!="")
        {

            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var project_name = jQuery.makeArray($('#project_name1').attr("value"));
                $("#loading").show();
                jQuery.ajax({url:'/projects/create?project_name=' + project_name, success :function(data) {

                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });


    $('#project_submit').click(function(e)
    {
        if ($('#project_name1').attr("value") == "")
        {
            alert("Please enter project name");
            $('#project_name1').focus();
            e.preventDefault();
        }
    });

    //When a member activate his account
    $('#member_submit').click(function(e)
    {
        var passwordfilter = /^(?=.*\d)(?=.*[a-zA-Z0-9])(?!.*\s).{6,20}$/i;
        if (($('#member_password').attr("value") == "") || (passwordfilter.test($("#member_password").val()) == false))
        {
            $("#checkPassword").html("").append("Passwords should be 6 characters or longer with at least one number")
            $('#checkPassword').css({'color':'red'});
            $("#checkPasswordCon").html("").append("");
            $('#member_password').focus();
            e.preventDefault();
        }
        else if (($('#member_password_confirmation').attr("value") == "") || ($("#member_password_confirmation").val() != $("#member_password").val()))
        {
            $("#checkPasswordCon").html("").append("Password confirmation should be match")
            $('#checkPasswordCon').css({'color':'red'});
            $("#checkPassword").html("").append("");
            $('#member_password_confirmation').focus();
            e.preventDefault();
        }
    });

    $("#member_password").live('focus', (function(e) {
        $("#checkPasswordCon").html("").append("");
    }));
    $("#member_password_confirmation").live('focus', (function(e) {
        $("#checkPassword").html("").append("");
    }));

    function popitup(url) {
        newwindow = window.open(url, 'name', 'height=200,width=150');
        if (window.focus) {
            newwindow.focus()
        }
        return false;
    }

    ;
    /* Add a member when user presses enter,tab or away  */
    $('#member_name1').click(function(e)
    {
        if ($('#member_name1').attr("value") == "<< Add new person's email address")
        {
            $('#member_name1').removeClass("inpTxt_ad rgt w400px");
            $('#member_name1').addClass("inpTxt_ad lft w400px");
            $(this).attr("value", "");
            $('#member_name1').focus();
            e.preventDefault();

        }


    });


    $('#member_name1').focusout(function(e)
    {
        var email = $('#member_name1').attr("value")
        if (email != "<< Add new person's email address" && email!="" )
        {
          var member_email1 = email.replace(/\./g, '*')
          $("#loading").show();
          jQuery.ajax({url:'/members/create/' + member_email1, success :function(data) {

          },error: hideLoadingImage,complete: hideLoadingImage})
        }
    });

    $('#member_name1').keypress(function(e)
    {
        if ($('#member_name1').attr("value") != "<< Add new person's email address" && $('#member_name1').attr("value")!="")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var email = $('#member_name1').attr("value")
                var member_email1 = email.replace(/\./g, '*')
                $("#loading").show();
                jQuery.ajax({url:'/members/create/' + member_email1, success :function(data) {

                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });

    /* Enter a pre-condition when user presses enter,tab or away  */
    $('#pre_condition').click(function(e)
    {
        if ($('#pre_condition').attr("value") == "<< Add pre-condition")
        {
            $(this).attr("value", "");
            $('#pre_condition').removeClass("inpTxt_ad rgt w400px");
            $('#pre_condition').addClass("inpTxt_ad lft w400px");
            $('#pre_condition').focus();
            e.preventDefault();

        }


    });


    $('#pre_condition').focusout(function(e)
    {
        if ($('#pre_condition').attr("value") != "")
        {
          var pre = jQuery.makeArray($('#pre_condition').attr("value"));
          $("#loading").show();
          jQuery.ajax({url:'/use_case_details/create_pre_condition?pre=' + pre, success :function(data) {
          },error: hideLoadingImage,complete: hideLoadingImage})
        }

    });

    $('#pre_condition').keypress(function(e)
    {
        if ($('#pre_condition').attr("value") != "<< Add pre-condition" && $('#pre_condition').attr("value") != "")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab

                var pre = jQuery.makeArray($('#pre_condition').attr("value"));
                $("#loading").show();
                jQuery.ajax({url:'/use_case_details/create_pre_condition?pre=' + pre, success :function(data) {
                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });

    /* Create a post-condition when user presses enter,tab or away  */
    $('#post_condition').click(function(e)
    {
        if ($('#post_condition').attr("value") == "<< Add post-condition")
        {
            $(this).attr("value", "");
            $('#post_condition').removeClass("inpTxt_ad rgt w400px");
            $('#post_condition').addClass("inpTxt_ad lft w400px");
            $('#post_condition').focus();
            e.preventDefault();

        }


    });


    $('#post_condition').focusout(function(e)
    {
        if ($('#post_condition').attr("value") != "")
        {
          var post = jQuery.makeArray($('#post_condition').attr("value"));
          $("#loading").show();
          jQuery.ajax({url:'/use_case_details/create_post_condition?post=' + post, success :function(data) {
          },error: hideLoadingImage,complete: hideLoadingImage})
        }   

    });

    $('#post_condition').keypress(function(e)
    {
        if ($('#post_condition').attr("value") != "<< Add post-condition" && $('#post_condition').attr("value") != "")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var post = jQuery.makeArray($('#post_condition').attr("value"));
                $("#loading").show();
                jQuery.ajax({url:'/use_case_details/create_post_condition?post=' + post, success :function(data) {
                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });

    /* Create a success-condition when user presses enter,tab or away  */
    $('#succ_condition').click(function(e)
    {
        if ($('#succ_condition').attr("value") == "<< Add success condition")
        {
            $(this).attr("value", "");
            $('#succ_condition').removeClass("inpTxt_ad rgt w400px");
            $('#succ_condition').addClass("inpTxt_ad lft w400px");
            $('#succ_condition').focus();
            e.preventDefault();

        }


    });


    $('#succ_condition').focusout(function(e)
    {
       if ($('#succ_condition').attr("value") != "")
       {
        var succ = jQuery.makeArray($('#succ_condition').attr("value"));
        $("#loading").show();
        jQuery.ajax({url:'/use_case_details/create_success_condition?succ=' + succ, success :function(data) {

        },error: hideLoadingImage,complete: hideLoadingImage})
       }
    });

    $('#succ_condition').keypress(function(e)
    {
        if ($('#succ_condition').attr("value") != "<< Add success condition" && $('#succ_condition').attr("value") != "")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var succ = jQuery.makeArray($('#succ_condition').attr("value"))
                $("#loading").show();
                jQuery.ajax({url:'/use_case_details/create_success_condition?succ=' + succ, success :function(data) {
                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });

    /* Create a trgigger when user presses enter,tab or away  */
    $('#trigger').click(function(e)
    {
        if ($('#trigger').attr("value") == "<< Add trigger")
        {
            $(this).attr("value", "");
            $('#trigger').removeClass("inpTxt_ad rgt w400px");
            $('#trigger').addClass("inpTxt_ad lft w400px");
            $('#trigger').focus();
            e.preventDefault();

        }


    });


    $('#trigger').focusout(function(e)
    {
        if ($('#trigger').attr("value") != "")
        {
          var trigger = jQuery.makeArray($('#trigger').attr("value"))
          $("#loading").show();
          jQuery.ajax({url:'/use_case_details/create_trigger?trigger=' + trigger, success :function(data) {

          },error: hideLoadingImage,complete: hideLoadingImage})
        }
    });

    $('#trigger').keypress(function(e)
    {
        if ($('#trigger').attr("value") != "<< Add trigger" && $('#trigger').attr("value") !="")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var trigger = jQuery.makeArray($('#trigger').attr("value"))
                $("#loading").show();
                jQuery.ajax({url:'/use_case_details/create_trigger?trigger=' + trigger, success :function(data) {
                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });

    /* Create a actor when user presses enter,tab or away  */
    $('#actor').click(function(e)
    {
        if ($('#actor').attr("value") == "<< Add actor")
        {
            $(this).attr("value", "");
            $('#actor').removeClass("inpTxt_ad rgt w400px");
            $('#actor').addClass("inpTxt_ad lft w400px");
            $('#actor').focus();
            e.preventDefault();

        }


    });


    $('#actor').focusout(function(e)
    {
       if ($('#actor').attr("value") != "")
       {
        var actor = $('#actor').attr("value")
        $("#loading").show();
        jQuery.ajax({url:'/use_case_details/create_actor/' + actor, success :function(data) {
        },error: hideLoadingImage,complete: hideLoadingImage})
       }

    });

    $('#actor').keypress(function(e)
    {
        if ($('#actor').attr("value") != "<< Add Actor" && $('#actor').attr("value") != "")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var actor = $('#actor').attr("value")
                $("#loading").show();
                jQuery.ajax({url:'/use_case_details/create_actor/' + actor, success :function(data) {
                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });

    /* Create a business rule when user presses enter,tab or away  */
    $('#business_rule').click(function(e)
    {
        if ($('#business_rule').attr("value") == "<< Add business rule")
        {
            $(this).attr("value", "");
            $('#business_rule').removeClass("inpTxt_ad rgt w400px");
            $('#business_rule').addClass("inpTxt_ad lft w400px");
            $('#business_rule').focus();
            e.preventDefault();

        }


    });


    $('#business_rule').focusout(function(e)
    {
      if ($('#business_rule').attr("value") != "")
      {
        var rule = jQuery.makeArray($('#business_rule').attr("value"))
        $("#loading").show();
        jQuery.ajax({url:'/use_case_details/create_business_rule?rule=' + rule, success :function(data) {

        },error: hideLoadingImage,complete: hideLoadingImage})
      }
    });

    $('#business_rule').keypress(function(e)
    {
        if ($('#business_rule').attr("value") != "<< Add business rule" && $('#business_rule').attr("value") !="")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var rule = jQuery.makeArray($('#business_rule').attr("value"))
                $("#loading").show();
                jQuery.ajax({url:'/use_case_details/create_business_rule?rule=' + rule, success :function(data) {
                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });

    /* Create a message when user presses enter,tab or away  */
    $('#use_message').click(function(e)
    {
        if ($('#use_message').attr("value") == "<< Add message")
        {
            $(this).attr("value", "");
            $('#use_message').removeClass("inpTxt_ad rgt w400px");
            $('#use_message').addClass("inpTxt_ad lft w400px");
            $('#use_message').focus();
            e.preventDefault();

        }


    });


    $('#use_message').focusout(function(e)
    {
       if ($('#use_message').attr("value") != "")
       {
        var msg = jQuery.makeArray($('#use_message').attr("value"))
        $("#loading").show();
        jQuery.ajax({url:'/use_case_details/create_message?msg=' + msg, success :function(data) {

        },error: hideLoadingImage,complete: hideLoadingImage})
       }
    });

    $('#use_message').keypress(function(e)
    {
        if ($('#use_message').attr("value") != "<< Add message" && $('#use_message').attr("value") != "")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var msg = jQuery.makeArray($('#use_message').attr("value"))
                $("#loading").show();
                jQuery.ajax({url:'/use_case_details/create_message?msg=' + msg, success :function(data) {
                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });
    /* Create a alternate flow when user presses enter,tab or away  */
    $('#alternate_flow').click(function(e)
    {
        if ($('#alternate_flow').attr("value") == "<< Add a title for the alternate flow")
        {
            $(this).attr("value", "");
            $('#alternate_flow').removeClass("inpTxt_ad rgt w400px");
            $('#alternate_flow').addClass("inpTxt_ad lft w400px");
            $('#alternate_flow').focus();
            e.preventDefault();

        }


    });


    $('#alternate_flow').focusout(function(e)
    {
      if ($('#alternate_flow').attr("value") != "")
      {
        var title = $('#alternate_flow').attr("value")
        $("#loading").show();
        jQuery.ajax({url:'/use_case_details/create_alter_flow?title=' + title, success :function(data) {

        },error: hideLoadingImage,complete: hideLoadingImage})
        $(".sortable").sortable({
        }).disableSelection();
      }   
    });

    $('#alternate_flow').keypress(function(e)
    {
        if ($('#alternate_flow').attr("value") != "<< Add a title for the alternate flow" && $('#alternate_flow').attr("value") != "")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var title = $('#alternate_flow').attr("value")
                $("#loading").show();
                jQuery.ajax({url:'/use_case_details/create_alter_flow?title=' + title, success :function(data) {
                },error: hideLoadingImage,complete: hideLoadingImage})
                $(".sortable").sortable({
                }).disableSelection();
            }


        }
    });

    /* Create a basic action and response when user presses enter,tab or away  */
    $('#use_basic_action').live('click', (function(e)
    {
        if ($('#use_basic_action').attr("value") == "<< Add a user action")
        {
            flag_basic = "true"
            $('#use_basic_action').removeClass("inpTxt_ad rgt w250px");
            $('#use_basic_action').addClass("inpTxt_ad lft w250px");
            $(this).attr("value", "");
            $('#use_basic_action').focus();
            e.preventDefault();

        }


    }));


    $('#use_basic_action').live('keypress', function(e)
    {

        if ($('#use_basic_action').attr("value") != "<< Add a user action")
        {

            if (e.which == 13)
            {
                var action1 = $('#use_basic_action').attr("value");
                if ($.trim(action1)!= "")
                {
                    jQuery.ajax({url:'/use_case_details/create_basic_flow?action1=' + action1, success :function(data) {
                    }})
                }
            }
        }

    });


    $('#use_basic_response').live("focusin", function(e)
    {
        if ($('#use_basic_response').attr("value") == "<< Add a system response")
        {
            flag_basic = "false"
            $(this).attr("value", "");
            $('#use_basic_response').removeClass("inpTxt_ad rgt w250px");
            $('#use_basic_response').addClass("inpTxt_ad lft w250px");
            $('#use_basic_response').focus();
            e.preventDefault();

        }


    });

    $('#use_basic_response').focusout(function(e)
    {
        flag_basic = "false"
        var action1 = $('#use_basic_action').attr("value")
        var response1 = $('#use_basic_response').attr("value")

        if ($.trim(action1)!="" && action1 != "<< Add a user action" && $.trim(response1)!="" && response1 != "<< Add a system response")
        {
            $("#loading").show();
            jQuery.ajax({url:'/use_case_details/create_basic_flow1?action1=' + action1 + '&response1=' + response1, success :function(data) {
            },error: hideLoadingImage,complete: hideLoadingImage})
        }
        else if ($.trim(action1)!="" && action1 != "<< Add a user action" && (response1 == "" || response1 == "<< Add a system response"))
        {
            $("#loading").show();
            jQuery.ajax({url:'/use_case_details/create_basic_flow?action1=' + action1, success :function(data) {
            },error: hideLoadingImage,complete: hideLoadingImage})
        }
        else if ((action1 == "" || action1 == "<< Add a user action") && $.trim(response1)!="" && response1 != "<< Add a system response")
        {
            $("#loading").show();
            jQuery.ajax({url:'/use_case_details/create_basic_flow2?response1=' + response1, success :function(data) {
            },error: hideLoadingImage,complete: hideLoadingImage})
        }
    });

    $('#use_basic_response').keypress(function(e)
    {
        flag_basic = "false"

        if ($('#use_basic_response').attr("value") != "<< Add a system response" && $('#use_basic_action').attr("value") != "<< Add a user action")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var action1 = $('#use_basic_action').attr("value")
                var response1 = $('#use_basic_response').attr("value")
                if ($.trim(action1)!="" && $.trim(response1)!="")
                {
                    $("#loading").show();
                    jQuery.ajax({url:'/use_case_details/create_basic_flow1?action1=' + action1 + '&response1=' + response1, success :function(data) {
                    },error: hideLoadingImage,complete: hideLoadingImage})
                }
                else if ($.trim(action1)!="" && (response1 == ""))
                {
                    
                    $("#loading").show();
                    jQuery.ajax({url:'/use_case_details/create_basic_flow?action1=' + action1, success :function(data) {
                    },error: hideLoadingImage,complete: hideLoadingImage})
                }
                else if (action1 == "" && $.trim(response1)!="")
                {
                    $("#loading").show();

                      jQuery.ajax({url:'/use_case_details/create_basic_flow2?response1=' + response1, success :function(data) {
                      },error: hideLoadingImage,complete: hideLoadingImage})

                }
            }


        }
    });

    /* Create a alter basic action and response when user presses enter,tab or away  */
    $('#add_use_case_detail1 textarea[id*=alter_use_basic_action_]').live('click', (function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("alter_use_basic_action_")[1]

        if ($('#alter_use_basic_action_' + b).attr("value") == "<< Add a user action")
        {
            flag_alter = "true"
            $(this).attr("value", "");
            $('#alter_use_basic_action_' + b).removeClass("inpTx rgt w190px");
            $('#alter_use_basic_action_' + b).addClass("inpTxt lft w190px");
            $('#alter_use_basic_action_' + b).focus();
            e.preventDefault();

        }


    }));


    $('#add_use_case_detail1 textarea[id*=alter_use_basic_action_]').live('keypress', (function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("alter_use_basic_action_")[1]
        if ($('#alter_use_basic_action_' + b).attr("value") != "<< Add a user action")
        {
            if (e.which == 13) { // if is enter
                var action1 = $('#alter_use_basic_action_' + b).attr("value");
                if (action1 != "")
                {
                    $("#loading1").show();
                    jQuery.ajax({url:'/use_case_details/create_alter_basic_flow?action1=' + action1 + '&id=' + b, success :function(data) {
                    },error: hideLoadingImage,complete: hideLoadingImage})
                }
            }
            else if (e.which == 9) { // if is tab
                $('#alter_use_basic_response_' + b).attr("value", "");
                $('#alter_use_basic_response_' + b).removeClass("inpTxt rgt w190px");
                $('#alter_use_basic_response_' + b).addClass("inpTxt lft w190px");
                $('#alter_use_basic_response_' + b).focus();
                e.preventDefault();
            }

        }


    }));

    $('#add_use_case_detail1 textarea[id*=alter_use_basic_response_]').live('focusin', (function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("alter_use_basic_response_")[1]
        flag_alter = "false"
        if ($('#alter_use_basic_response_' + b).attr("value") == "<< Add a system response")
        {
            $(this).attr("value", "");
            $('#alter_use_basic_response_' + b).removeClass("inpTxt rgt w190px");
            $('#alter_use_basic_response_' + b).addClass("inpTxt lft w190px");
            $('#alter_use_basic_response_' + b).focus();
            e.preventDefault();

        }


    }));

    $('#add_use_case_detail1 textarea[id*=alter_use_basic_response_]').live('focusout', (function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("alter_use_basic_response_")[1]
        flag_alter = "false"
        var action1 = $('#alter_use_basic_action_' + b).attr("value")
        var response1 = $('#alter_use_basic_response_' + b).attr("value")
        if (action1 != "" && action1 != "<< Add a user action" && response1 != "" && response1 != "<< Add a system response")
        {
            $("#loading1").show();
            jQuery.ajax({url:'/use_case_details/create_alter_basic_flow1?action1=' + action1 + '&response1=' + response1 + '&id=' + b, success :function(data) {
            },error: hideLoadingImage,complete: hideLoadingImage})
        }
        else if (action1 != "" && action1 != "<< Add a user action" && (response1 == "" || response1 == "<< Add a system response"))
        {
            $("#loading1").show();
            jQuery.ajax({url:'/use_case_details/create_alter_basic_flow?action1=' + action1 + '&id=' + b, success :function(data) {
            },error: hideLoadingImage,complete: hideLoadingImage})
        }
        else if ((action1 == "" || action1 == "<< Add a user action") && response1 != "" && response1 != "<< Add a system response")
        {
            $("#loading1").show();
            jQuery.ajax({url:'/use_case_details/create_alter_basic_flow2?action1' + response1 + '&id=' + b, success :function(data) {
            },error: hideLoadingImage,complete: hideLoadingImage})
        }
    }));

    $('#add_use_case_detail1 textarea[id*=alter_use_basic_response_]').live('keypress', (function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("alter_use_basic_response_")[1]
        flag_alter = "false"
        if ($('#alter_use_basic_response_' + b).attr("value") != "<< Add a system response" && $('#alter_use_basic_action_' + b).attr("value") != "<< Add a user action")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var action1 = $('#alter_use_basic_action_' + b).attr("value")
                var response1 = $('#alter_use_basic_response_' + b).attr("value")
                if (action1 != "" && action1 != "<< Add a user action" && response1 != "" && response1 != "<< Add a system response")
                {
                    $("#loading1").show();
                    jQuery.ajax({url:'/use_case_details/create_alter_basic_flow1?action1=' + action1 + '&response1=' + response1 + '&id=' + b, success :function(data) {
                    },error: hideLoadingImage,complete: hideLoadingImage})
                }
                else if (action1 != "" && action1 != "<< Add a user action" && (response1 == "" || response1 == "<< Add a system response"))
                {
                    $("#loading1").show();
                    jQuery.ajax({url:'/use_case_details/create_alter_basic_flow?action1=' + action1 + '&id=' + b, success :function(data) {
                    },error: hideLoadingImage,complete: hideLoadingImage})
                }
                else if ((action1 == "" || action1 == "<< Add a user action") && response1 != "" && response1 != "<< Add a system response")
                {
                    $("#loading1").show();
                    jQuery.ajax({url:'/use_case_details/create_alter_basic_flow2?response1=' + response1 + '&id=' + b, success :function(data) {
                    },error: hideLoadingImage,complete: hideLoadingImage})
                }
            }


        }
    }));

    /* Show save and cancel  button corresponding to the pre-condition */
    $("#add_use_case_detail textarea[id*=pre_condition_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("pre_condition_")[1]
        $("#show_save_cancel_" + b).show();

    });

    /* Change background of  pre-condition field */
    $("#add_use_case_detail textarea[id*=pre_condition_]").live('mouseover', function(e)
    {
        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#add_use_case_detail textarea[id*=pre_condition_]").live('mouseout', function(e)
    {

        $(this).css("background", "#fff");
        //$(this).focusout();


    });

    /* Show save and cancel  button corresponding to the post-condition */
    $("#add_use_case_detail textarea[id*=post_condition_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("post_condition_")[1]
        $("#show_save_cancel_" + b).show();

    });

    /* Change background of  post-condition field */
    $("#add_use_case_detail textarea[id*=post_condition_]").live('mouseover', function(e)
    {
        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#add_use_case_detail textarea[id*=post_condition_]").live('mouseout', function(e)
    {

        $(this).css("background", "#fff");
        //$(this).focusout();
    });

    /* Show save and cancel  button corresponding to the success-condition */
    $("#add_use_case_detail textarea[id*=succ_condition_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("succ_condition_")[1]
        $("#show_save_cancel_" + b).show();

    });
    /* Change background of  success-condition field */
    $("#add_use_case_detail textarea[id*=succ_condition_]").live('mouseover', function(e)
    {
        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#add_use_case_detail textarea[id*=succ_condition_]").live('mouseout', function(e)
    {

        $(this).css("background", "#fff");
        //$(this).focusout();
    });

    /* Show save and cancel  button corresponding to the trgigger*/
    $("#add_use_case_detail textarea[id*=trigger_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("trigger_")[1]
        $("#show_save_cancel_" + b).show();

    });
     /* Change background of  trigger field */
    $("#add_use_case_detail textarea[id*=trigger_]").live('mouseover', function(e)
    {
        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#add_use_case_detail textarea[id*=trigger_]").live('mouseout', function(e)
    {

        $(this).css("background", "#fff");
        //$(this).focusout();
    });

    /* Show save and cancel  button corresponding to the actor*/
    $("#add_use_case_detail input[id*=actor_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("actor_")[1]
        $("#show_save_cancel_" + b).show();

    });

    /* Show save and cancel  button corresponding to the business rule*/
    $("#add_use_case_detail textarea[id*=business_rule_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("business_rule_")[1]
        $("#show_save_cancel_" + b).show();

    });
    /* Change background of  business rule field */
    $("#add_use_case_detail textarea[id*=business_rule_]").live('mouseover', function(e)
    {
        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#add_use_case_detail textarea[id*=business_rule_]").live('mouseout', function(e)
    {

        $(this).css("background", "#fff");
        //$(this).focusout();
    });

    /* Show save and cancel  button corresponding to the message*/
    $("#add_use_case_detail textarea[id*=message_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("message_")[1]
        $("#show_save_cancel_" + b).show();

    });

    $("#add_use_case_detail textarea[id*=message_content_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("message_content_")[1]
        $("#show_save_cancel_" + b).show();

    });

    /* Change background of  message field */
    $("#add_use_case_detail textarea[id*=message_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("message_")[1]
        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        $("#message_content_" + b).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#add_use_case_detail textarea[id*=message_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("message_")[1]
        $(this).css("background", "#fff");
        $("#message_content_" + b).css("background", "#fff");
        //$(this).focusout();
    });


    $("#add_use_case_detail textarea[id*=message_content_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("message_content_")[1]
        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        $("#message_" + b).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#add_use_case_detail textarea[id*=message_content_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("message_content_")[1]
        $(this).css("background", "#fff");
        $("#message_" + b).css("background", "#fff");
        //$(this).focusout();
    });

    /* Show save and cancel  button corresponding to the base action and response*/
    $("#add_use_case_detail textarea[id*=basic_action_]").live('click', function(e)
    {

        input_id = $(this).attr('id');
        b = input_id.split("basic_action_")[1]

        text_value1=$("#basic_action_"+ b).attr("value");
        $("#show_save_cancel_" + b).show();
        $(this).focus();


    });
    $("#add_use_case_detail textarea[id*=basic_response_]").live('click', function(e)
    {

        input_id = $(this).attr('id');
        b = input_id.split("basic_response_")[1]

        text_value2=$("#basic_response_"+ b).attr("value");

        $("#show_save_cancel_" + b).show();

        $(this).focus();

    });


    $("#add_use_case_detail a[id*=add_save_cancel_hide_]").live('click', function(e)
    {

        input_id = $(this).attr('id');
        b = input_id.split("add_save_cancel_hide_")[1]
        if (text_value1!= "preserve_value")
        {
          $("#basic_action_"+ b).attr("value",text_value1);
          text_value1="preserve_value"

        }
        if (text_value2!="preserve_value")
        {
          $("#basic_response_"+ b).attr("value",text_value2);
          text_value2="preserve_value"  

        }

        $("#show_save_cancel_" + b).hide();


    });
    /* Show save and cancel  button corresponding to the alternate flow*/
    $("#add_use_case_detail1 input[id*=alternate_flow_]").live('click', function(e)
    {

        input_id = $(this).attr('id');
        b = input_id.split("alternate_flow_")[1]
        $('#alternate_flow_' + b).removeClass("inpTx rgt w400px");
        $('#alternate_flow_' + b).addClass("inpTxt lft w400px");
        $("#show_alter_" + b).show();
        $("#add_alternate_" + b).show();
        $("#edit_alternate_" + b).show();


    });
    /* Hide save and cancel  button corresponding to the alternate flow*/
    $("#add_use_case_detail1 a[id*=alter_hide_save_cancel_]").live('click', function(e)
    {

        input_id = $(this).attr('id');
        b = input_id.split("alter_hide_save_cancel_")[1]
        $('#alternate_flow_' + b).removeClass("inpTx lft w400px");
        $('#alternate_flow_' + b).addClass("inpTxt rgt w400px");
        $("#show_alter_" + b).hide();
        $("#edit_alternate_" + b).hide();
        $("#add_alternate_" + b).hide();

    });

    $("#add_use_case_detail1 textarea[id*=alter_basic_action_]").live('click', function(e)
    {

        input_id = $(this).attr('id');
        b = input_id.split("alter_basic_action_")[1]

        $("#show_alter_basic_" + b).show();
        $(this).focus();

    });
    $("#add_use_case_detail1 textarea[id*=alter_basic_response_]").live('click', function(e)
    {

        input_id = $(this).attr('id');
        b = input_id.split("alter_basic_response_")[1]

        $("#show_alter_basic_" + b).show();
        $(this).focus();

    });


    $("#add_use_case_detail1 a[id*=alter_basic_hide_]").live('click', function(e)
    {

        input_id = $(this).attr('id');
        b = input_id.split("alter_basic_hide_")[1]

        $("#show_alter_basic_" + b).hide();


    });

    $('#user_submit').live('click', (function(e)
    {

        var emailfilter = /^\w+[\+\.\w-]*@([\w-]+\.)*\w+[\w-]*\.([a-z]{2,4}|\d+)$/i;
        var passwordfilter = /^(?=.*\d)(?=.*[a-zA-Z0-9])(?!.*\s).{6,20}$/i;
        var flag = false
        if ($("#user_email").length)
        {
            if (($("#user_email").val() == "") || (emailfilter.test($("#user_email").val()) == false))
            {
                $("#checkEmail").html("").append("Please enter valid email")
                $('#checkEmail').css({'color':'red'});
                //$("#user_email").focus();
                flag = true

            }
            if (($("#user_password").val() == "") || (passwordfilter.test($("#user_password").val()) == false))
            {
                $("#checkPassword").html("").append("Passwords should be 6 characters or longer with at least one number")
                $('#checkPassword').css({'color':'red'});
                //$("#checkEmail").html("").append("");
                //$("#user_password").focus();
                flag = true

            }
            if (($("#user_password_confirmation").val() == "") || ($("#user_password_confirmation").val() != $("#user_password").val()))
            {

                $("#checkPasswordCon").html("").append("The passwords you entered do not match.Please try again.")
                $('#checkPasswordCon').css({'color':'red'});
                //$("#checkEmail").html("").append("");
                //$("#checkPassword").html("").append("")
                //$("#user_password_confirmation").focus();
                flag = true
            }
            if (flag == true)
            {
                e.preventDefault();
            }
        }
        else
        {
            if (($("#user_old_password").val() == ""))
            {
                $("#old_password_error").html("").append("Please enter your current password")
                $('#old_password_error').css({'color':'red'});
                $("#user_old_password").focus();
                e.preventDefault();

            }
            if (($("#user_password").val() == "") || (passwordfilter.test($("#user_password").val()) == false))
            {
                $("#checkPassword").html("").append("Passwords should be 6 characters or longer with at least one number")
                $('#checkPassword').css({'color':'red'});
                $("#user_password").focus();
                e.preventDefault();

            }
            else if (($("#user_password_confirmation").val() == "") || ($("#user_password_confirmation").val() != $("#user_password").val()))
            {

                $("#checkPasswordCon").html("").append("The passwords you entered do not match.Please try again.")
                $('#checkPasswordCon').css({'color':'red'});
                $("#user_password_confirmation").focus();
                e.preventDefault();
            }
        }

    }));


    $("#user_old_password").live('focusout', (function(e) {

        if (($("#user_old_password").val() == ''))
        {
            $("#user_old_password").focus();
            $("#old_password_error").html("").append("Please enter your current password")
            $('#old_password_error').css({'color':'red'});
            e.preventDefault();
        }
        else
        {
            $("#old_password_error").html("").append("")
            $("#user_password").focus();
            e.preventDefault();
        }

    }));


    function my_code() {

        $("#first_name").focus();
        $("#user_email").focus();

    }

    window.onload = new function() {
        //$("#req_use_case_name").focus();
        //$("#usecase_requirement").focus();
    };
    $('#first_name').focusout(function(e) {
        {
            var first_name = $("#first_name").val();
            if ((first_name == '') || (first_name.length < 2))
            {
                //$('#first_name').focus();
                $("#first_name_error").html("").append("First name must contain at least two characters")
                $('#first_name_error').css({'color':'red'});
                e.preventDefault();
            }
            else
            {
                $("#first_name_error").html("").append("");
                $("#last_name").focus();
                e.preventDefault();
            }

        }
    });
    $('#last_name').focusout(function(e) {
        {
            var last_name = $("#last_name").val();
            if ((last_name == '') || (last_name.length < 2))
            {
                //$('#last_name').focus();
                $("#last_name_error").html("").append("Last name must contain at least two characters")
                $('#last_name_error').css({'color':'red'});
                e.preventDefault();
            }
            else
            {
                $("#last_name_error").html("").append("")
                $("#subdomain").focus();
                e.preventDefault();
            }
        }

    });

    $('#subdomain').focusout(function(e) {
        {
            var subdomain = $("#subdomain").val();
            if ((subdomain == ''))
            {
                //$('#address').focus();
                $("#subdomain_error").html("").append("Sub domain can not be blank.")
                $('#subdomain_error').css({'color':'red'});
                e.preventDefault();
            }
           else
            {
                $.ajax({url: '/users/check_domain/' + subdomain,success:function(data) {
                        var obj = $.parseJSON(data);
                        //alert(data);
                        if (obj==true)
                        {
                          $("#subdomain_error").html("").append("Sub domain should be unique.")
                          $('#subdomain_error').css({'color':'red'});
                          e.preventDefault();
                        }
                        else
                        {
                          $("#subdomain_error").html("").append("")
                          $("#address").focus();
                          e.preventDefault();
                        }
                    }
                })    


            }
          
        }
    });

    $('#address').focusout(function(e) {
        {
            var address = $("#address").val();
            if ((address == '') || (address.length < 2))
            {
                //$('#address').focus();
                $("#address_error").html("").append("Billing Address must contain at least two characters")
                $('#address_error').css({'color':'red'});
                e.preventDefault();
            }
            else
            {
                $("#address_error").html("").append("")
                $("#city").focus();
                e.preventDefault();
            }
        }
    });

    $('#city').focusout(function(e) {
        {
            var city = $("#city").val();
            if ((city == '') || (city.length < 2))
            {
                //$('#city').focus();
                $("#city_error").html("").append("City must contain at least 2 characters")
                $('#city_error').css({'color':'red'});
                e.preventDefault();
            }
            else
            {
                $("#city_error").html("").append("")
                $("#zip").focus();
                e.preventDefault();
            }
        }
    });

    $('#zip').focusout(function(e) {
        {
            var zip = $("#zip").val();
            if ((zip == '') || (zip.length < 2))
            {
                //$('#zip').focus();
                $("#zip_error").html("").append("Zip code must contain at least 2 characters")
                $('#zip_error').css({'color':'red'});
                e.preventDefault();
            }
            else
            {
                $("#zip_error").html("").append("")
                $("#country_").focus();
                e.preventDefault();
            }
        }
    });

    $('select#country_').focusout(function(e) {
        {
            var country = $("select#country_ option:selected").text();
            //alert(country);
            if (country == '--Select--')
            {

                $("#country_error").html("").append("You must select a country from the list")
                $('#country_error').css({'color':'red'});
                //$(this).focus();
                e.preventDefault();
            }
            else
            {
                $("#country_error").html("").append("")
                $("#phone").focus();
                e.preventDefault();
            }
        }
    });
      $('select#payment_type_').focusout(function(e) {
           {
               var payment_type = $("select#payment_type_ option:selected").text();

               if (payment_type == '--Select--')
               {

                   $("#payment_type_error").html("").append("You must select a Payment type from the list")
                   $('#payment_type_error').css({'color':'red'});
                   //$(this).focus();
                   e.preventDefault();
               }
               else
               {
                   $("#payment_type_error").html("").append("")

                   e.preventDefault();
               }
           }
       });

     $('#accept_check').click(function()
        {
            if ($(this).attr('checked'))
            {    $("#accept_check_error").html("")
                  $("#payment_submit").focus();


                //$('#payment_submit1').attr('disabled', false)
            }
            else
            {
                $("#accept_check_error").html("").append("You must have to accept")
                $('#accept_check_error').css({'color':'red'});

            }

        });

    $('#phone').focusout(function(e) {
        {
            var phone = $("#phone").val();
            if (phone == '')
            {
                //$('#phone').focus();
                $("#phone").html("").append("You must enter a valid international phone number")
                $('#phone_error').css({'color':'red'});
                e.preventDefault();
            }
            else
            {
                $("#phone_error").html("").append("");
            }


        }
    });


    $("#user_email").focusout(function(e) {

        var userEmail = $("#user_email").val();
        var filter = /^\w+[\+\.\w-]*@([\w-]+\.)*\w+[\w-]*\.([a-z]{2,4}|\d+)$/i;
        if ((userEmail == '') || (filter.test($("#user_email").val()) == false ))
        {
            //$("#user_email").focus();
            $("#checkEmail").html("").append("Please enter a valid email address")
            $('#checkEmail').css({'color':'red'});
            e.preventDefault();
        }
        else
        {
            $.ajax({url:'/users/check_email?email=' + userEmail, dataType: "json",success: function(data) {


                if (data.result != "Emails must be unique, another user is already using that email.")
                {
                    $("#checkEmail").html("").append("")
                    $("#user_password").focus();
                }
                else
                {

                    $('.flash_error_out').html("The email you entered already exists.");
                }
            }})


            e.preventDefault();
        }

    });
    $("#user_password").live('focusout', (function(e) {

        var userPassword = $("#user_password").val();
        var filter = /^(?=.*\d)(?=.*[a-zA-Z0-9]).{6,20}$/i;
        if ((userPassword == '') || (filter.test($("#user_password").val()) == false ))
        {
            //$("#user_password").focus();
            $("#checkPassword").html("").append("Passwords should be 6 characters or longer with at least one number")
            $('#checkPassword').css({'color':'red'});
            e.preventDefault();
        }
        else
        {
            $("#checkPassword").html("").append("")
            $("#user_password_confirmation").focus();
            e.preventDefault();
        }

    }));

    $("#user_password_confirmation").live('focusout', (function(e) {

        var userPassword = $("#user_password").val();
        var userPasswordCon = $("#user_password_confirmation").val();
        if ((userPasswordCon == '') || (userPassword != userPasswordCon))
        {
            //$("#user_password_confirmation").focus();
            $("#checkPasswordCon").html("").append("The passwords you entered do not match.Please try again.")
            $('#checkPasswordCon').css({'color':'red'});
            e.preventDefault();
        }
        else
        {
            $("#checkPasswordCon").html("").append("")
        }
    }));


    $('#user_session_submit').live('click', (function(e)
    {


        if (($("#user_session_email").val() == "") && ($("#user_session_password").val() != ""))
        {
            $("#checkEmail").html("").append("Please enter email")
            $('#checkEmail').css({'color':'red'});
            $("#user_session_email").focus();
            e.preventDefault();

        }
        else
        if (($("#user_session_email").val() != "") && ($("#user_session_password").val() == ""))
        {
            $("#checkPassword").html("").append("Please enter password")
            $('#checkPassword').css({'color':'red'});
            $("#user_session_password").focus();
            e.preventDefault();

        }
        else
        if (($("#user_session_email").val() == "") && ($("#user_session_password").val() == ""))
        {
            $("#checkEmail").html("").append("Please enter email")
            $('#checkEmail').css({'color':'red'});
            $("#checkPassword").html("").append("Please enter password")
            $('#checkPassword').css({'color':'red'});
            $("#user_session_email").focus();
            e.preventDefault();
        }

    }));

    $("#user_session_email").focusout(function(e) {

        if (($("#user_session_email").val() == ""))
        {
            $("#user_session_email").focus();
            $("#checkEmail").html("").append("Please enter email")
            $('#checkEmail').css({'color':'red'});
            e.preventDefault();
        }
        else
        {
            $("#checkEmail").html("").append("")
            if (($("#user_session_password").val() == ""))
            {
                $("#user_session_password").focus();
            e.preventDefault();
            }
        }
    });

    $("#user_session_password").focusout(function(e) {

        if (($("#user_session_password").val() == ""))
        {
            //$("#user_session_password").focus();
            $("#checkPassword").html("").append("Please enter password")
            $('#checkPassword').css({'color':'red'});
            e.preventDefault();
        }
        else
        {
            $("#checkPassword").html("").append("")


        }
    });


    $('#tracker_name').click(function(e)
    {
        if ($('#tracker_name').attr("value") == "<< Add tracker")
        {
            $(this).attr("value", "");
            $('#tracker_name').removeClass("inpTxt_ad rgt w400px");
            $('#tracker_name').addClass("inpTxt_ad lft w400px");
            $('#tracker_name').focus();
            e.preventDefault();

        }


    });


    $('#tracker_name').focusout(function(e)
    {
       if ($('#tracker_name').attr("value") !="")
       {
        var tracker_name = jQuery.makeArray($('#tracker_name').attr("value"));
        $("#loading").show();
        jQuery.ajax({url:'/trackers/create?tracker_name=' + tracker_name, success :function(data) {

        },error: hideLoadingImage,complete: hideLoadingImage})
       }
    });

    $('#tracker_name').keypress(function(e)
    {
        if ($('#tracker_name').attr("value") != "<< Add tracker" && $('#tracker_name').attr("value") !="")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var tracker_name = jQuery.makeArray($('#tracker_name').attr("value"));
                $('#loading').show();
                jQuery.ajax({url:'/trackers/create?tracker_name=' + tracker_name, success :function(data) {

                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });
    $('#add_tracker input[id*=track_flag_]').live('click', (function(e)
    {
        input_id = $(this).attr('id');
        id = input_id.split("track_flag_")[1]
        if ($(this).attr('checked')) {

            var tracker_flag = $(this).attr("checked")
            jQuery.ajax({url:'/trackers/tracker_flag/' + tracker_flag + '/' + id, success :function(data) {

            }})


        }
        else
        {

            var tracker_flag = $(this).attr("checked")
            jQuery.ajax({url:'/trackers/tracker_flag/' + tracker_flag + '/' + id, success :function(data) {

            }})


        }


    }));

    $('#add_tracker input[id*=track_usecase_flag_]').live('click', (function(e)
    {
        input_id = $(this).attr('id');
        id = input_id.split("track_usecase_flag_")[1]
        if ($(this).attr('checked')) {

            var tracker_flag = $(this).attr("checked")
            jQuery.ajax({url:'/trackers/tracker_flag_usecase/' + tracker_flag + '/' + id, success :function(data) {

            }})


        }
        else
        {

            var tracker_flag = $(this).attr("checked")
            jQuery.ajax({url:'/trackers/tracker_flag_usecase/' + tracker_flag + '/' + id, success :function(data) {

            }})


        }


    }));

    $('#add_tracker input[id*=track_req_flag_]').live('click', (function(e)
    {
        input_id = $(this).attr('id');
        id = input_id.split("track_req_flag_")[1]
        if ($(this).attr('checked')) {

            var tracker_flag = $(this).attr("checked")
            jQuery.ajax({url:'/trackers/tracker_flag_req/' + tracker_flag + '/' + id, success :function(data) {

            }})


        }
        else
        {

            var tracker_flag = $(this).attr("checked")
            jQuery.ajax({url:'/trackers/tracker_flag_req/' + tracker_flag + '/' + id, success :function(data) {

            }})


        }


    }));

    //Link  a tracker to requirement
    $('#tracker_req_name').click(function(e)
    {
        if ($('#tracker_req_name').attr("value") == "<< Start typing to add a tracker")
        {
            $(this).attr("value", "");
            $('#tracker_req_name').removeClass("inpTxt_ad rgt w400px");
            $('#tracker_req_name').addClass("inpTxt_ad lft w400px");

            $('#tracker_req_name').focus();
            e.preventDefault();

        }


    });


    $('#tracker_req_name').focusout(function(e)
    {
        if ($('#tracker_req_name').attr("value") != "<< Start typing to add a tracker" && $('#tracker_req_name').attr("value")!="")
        {
            var tracker_name = jQuery.makeArray($('#tracker_req_name').attr("value"));
            $("#loading").show();
            jQuery.ajax({url:'/trackers/create_tracker_req?tracker_name=' + tracker_name, success :function(data) {

            },error: hideLoadingImage,complete: hideLoadingImage})
        }
    });

    $('#tracker_req_name').keypress(function(e)
    {
        if ($('#tracker_req_name').attr("value") != "<< Start typing to add a tracker" && $('#tracker_req_name').attr("value")!="")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var tracker_name = jQuery.makeArray($('#tracker_req_name').attr("value"));
                $("#loading").show();
                jQuery.ajax({url:'/trackers/create_tracker_req?tracker_name=' + tracker_name, success :function(data) {

                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });
    //End link a tracker to requirement
    $('#tracker_use_name').click(function(e)
    {
        if ($('#tracker_use_name').attr("value") == "<< Start typing to add a tracker")
        {
            $(this).attr("value", "");
            $('#tracker_use_name').removeClass("inpTxt_ad rgt w400px");
            $('#tracker_use_name').addClass("inpTxt_ad lft w400px");

            $('#tracker_use_name').focus();
            e.preventDefault();

        }


    });


    $('#tracker_use_name').focusout(function(e)
    {
        if ($('#tracker_use_name').attr("value")!= "<< Start typing to add a tracker" && $.trim($('#tracker_use_name').attr("value"))!="")
        {
        var tracker_name = jQuery.makeArray($('#tracker_use_name').attr("value"));
        $("#loading").show();
        jQuery.ajax({url:'/trackers/create_tracker_use?tracker_name=' + tracker_name, success :function(data) {

        },error: hideLoadingImage,complete: hideLoadingImage})
        }
    });

    $('#tracker_use_name').keypress(function(e)
    {
        if ($('#tracker_use_name').attr("value")!= "<< Start typing to add a tracker" && $.trim($('#tracker_use_name').attr("value"))!="")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var tracker_name = jQuery.makeArray($('#tracker_use_name').attr("value"));
                $("#loading").show();
                jQuery.ajax({url:'/trackers/create_tracker_use?tracker_name=' + tracker_name, success :function(data) {

                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });


    $('textarea[id*=req_comment_]').live('click', (function(e)
    {


        if ($(this).attr("value") == "<< Add comment")
        {
            $(this).removeClass("inpTxt rgt w400px");
            $(this).addClass("inpTxt lft w400px");
            $(this).attr("value", "");
            $(this).focus();
            e.preventDefault();

        }


    }));


    $('textarea[id*=req_comment_]').live('focusout', (function(e)
    {

        //var req_id=$('#req_id').attr("value")
        input_id = $(this).attr('id');
        id = input_id.split("req_comment_")[1]
        var comment = $(this).attr("value")
        if ($.trim(comment)!="")
        {
        jQuery.ajax({url:'/requirements/create_comment?comment=' + comment + '&id=' + id, success :function(data) {

        }})
        }
    }));

    $('textarea[id*=req_comment_]').live('keypress', (function(e)
    {


        if ($(this).attr("value") != "<< Add comment")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var comment = $(this).attr("value")
                input_id = $(this).attr('id');
                id = input_id.split("req_comment_")[1]
                if ($.trim(comment)!="")
                {
                jQuery.ajax({url:'/requirements/create_comment?comment=' + comment + '&id=' + id, success :function(data) {

                }})
                }
            }


        }
    }));


    $('textarea[id*=use_comment_]').live('click', (function(e)
    {
        input_id = $(this).attr('id');
        id = input_id.split("use_comment_")[1]
        if ($(this).attr("value") == "<< Add comment")
        {
            $(this).removeClass("inpTxt rgt w400px");
            $(this).addClass("inpTxt lft w400px");
            $(this).attr("value", "");
            $(this).focus();
            e.preventDefault();

        }


    }));


    $('textarea[id*=use_comment_]').live('focusout', (function(e)
    {
        input_id = $(this).attr('id');
        id = input_id.split("use_comment_")[1]
        var comment = $(this).attr("value")
        if ($.trim(comment)!="")
        {
        jQuery.ajax({url:'/use_cases/create_comment/' + comment + '/' + id, success :function(data) {

        }})
        }
    }));

    $('textarea[id*=use_comment_]').live('keypress', (function(e)
    {
        input_id = $(this).attr('id');
        id = input_id.split("use_comment_")[1]
        if ($(this).attr("value") != "<< Add comment")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var comment = $(this).attr("value")
                if ($.trim(comment)!="")
                {
                jQuery.ajax({url:'/use_cases/create_comment/' + comment + '/' + id, success :function(data) {

                }})
                }
            }


        }
    }));

    $('textarea[id*=tracker_comment_]').live('click', (function(e)
    {
        input_id = $(this).attr('id');
        id = input_id.split("tracker_comment_")[1]
        if ($(this).attr("value") == "<< Add comment")
        {

            $(this).attr("value", "");
            $(this).removeClass("inpTxt rgt w400px");
            $(this).addClass("inpTxt lft w400px");
            $(this).focus();
            e.preventDefault();

        }


    }));


    $('textarea[id*=tracker_comment_]').live('focusout', (function(e)
    {
        input_id = $(this).attr('id');
        id = input_id.split("tracker_comment_")[1]
        var comment = $(this).attr("value")
        if ($.trim(comment)!="")
        {
        jQuery.ajax({url:'/trackers/create_comment?comment=' + comment + '&id=' + id, success :function(data) {

        }})
        }
    }));

    $('textarea[id*=tracker_comment_]').live('keypress', (function(e)
    {
        input_id = $(this).attr('id');
        id = input_id.split("tracker_comment_")[1]
        if ($(this).attr("value") != "<< Add comment")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var comment = $(this).attr("value")
                if ($.trim(comment)!="")
                {
                jQuery.ajax({url:'/trackers/create_comment?comment=' + comment + '&id=' + id, success :function(data) {

                }})
                }
            }


        }
    }));

    $('.calendar').live('focusin', function() {
        $(this).datepicker();
    });

    $('#term1').live('click', (function(e)
    {
        if ($('#term1').attr("value") == "<< Add term")
        {
            $(this).attr("value", "");
            $('#term1').removeClass("inpTxt_ad w155px rgt");
            $('#term1').addClass("inpTxt_ad w155px lft");
            $('#term1').focus();
            flag_def = "true"
       
            e.preventDefault();

        }


    }));

    $(document).click(function(e)
    {

        
        if (($('#term1').attr("value") != "<< Add term") && $('#term1').attr("value") != "" && flag_def == "true")
        {
            
            flag_def = "false"
            var term = $('#term1').attr("value")
            var def = $('#definition1').attr("value")
            $("#loading").show();
            jQuery.ajax({url:'/definitions/create_term?term=' + term + '&def=' + def, success :function(data) {

            },error: hideLoadingImage,complete: hideLoadingImage});
        }
        else if (($('#use_basic_action').attr("value") != "<< Add a user action") && $.trim($('#use_basic_action').attr("value")) != "" && flag_basic == "true")
        {
            flag_basic = "false"
            var action1 = $('#use_basic_action').attr("value");
            $("#loading").show();
            jQuery.ajax({url:'/use_case_details/create_basic_flow?action1=' + action1, success :function(data) {
            },error: hideLoadingImage,complete: hideLoadingImage})
        }
        else if (flag_alter == "true")
        {
            input_id = $('#add_use_case_detail1 textarea[id*=alter_use_basic_action_]').attr('id');
            b = input_id.split("alter_use_basic_action_")[1]
            var action1 = $('#alter_use_basic_action_' + b).attr("value");
            if (action1 != "" && action1 != "<< Add a user action")
            {
                flag_alter = "false"
                $("#loading1").show();
                jQuery.ajax({url:'/use_case_details/create_alter_basic_flow?action1=' + action1 + '&id=' + b, success :function(data) {
                },error: hideLoadingImage,complete: hideLoadingImage})
            }

        }
    });


    $('#term1').live('keypress', (function(e)
    {

        if (($('#term1').attr("value") != "<< Add term") && $('#term1').attr("value") != "")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                if ($('#definition1').attr("value") == "<< Add definition" || $('#definition1').attr("value") == "")
                {
                    $('#definition1').removeClass("inpTxt_ad w405px rgt");
                    $('#definition1').addClass("inpTxt_ad w405px lft");
                    $('#definition1').focus();
                    $('#definition1').attr("value", "");
                    e.preventDefault();
                }
                else
                {
                    var term = $('#term1').attr("value")
                    var def = $('#definition1').attr("value")
                    $("#loading").show();
                    jQuery.ajax({url:'/definitions/create_term?term=' + term + '&def=' + def, success :function(data) {
                    },error: hideLoadingImage,complete: hideLoadingImage});

                }

            }


        }
    }));


    $('#definition1').live('focusin', (function(e)
    {
        if ($('#definition1').attr("value") == "<< Add definition")
        {
            flag_def = "false"
            $(this).attr("value", "");
            $('#definition1').removeClass("inpTxt_ad w405px rgt");
            $('#definition1').addClass("inpTxt_ad w405px lft");
            $('#definition1').focus();
            e.preventDefault();

        }


    }));

    $('#definition1').live('click', (function(e)
    {
        if ($('#definition1').attr("value") == "<< Add definition")
        {
            $(this).attr("value", "");
            $('#definition1').removeClass("inpTxt_ad w405px rgt");
            $('#definition1').addClass("inpTxt_ad w405px lft");
            $('#definition1').focus();
            e.preventDefault();

        }


    }));


    $('#definition1').live('keypress', (function(e)
    {

        if (($('#definition1').attr("value") != "<< Add definition") && $('#definition1').attr("value") != "")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab

                if ($('#term1').attr("value") == "<< Add term")
                {
                    $('#term1').removeClass("inpTxt_ad w155px rgt");
                    $('#term1').addClass("inpTxt_ad w155px lft");
                    $('#term1').focus();
                    $('#term1').attr("value", "");
                    flag_def = "true"
                    e.preventDefault();
                }
                else
                {
                    var term = $('#term1').attr("value")
                    var def = $('#definition1').attr("value")
                    $("#loading").show();
                    jQuery.ajax({url:'/definitions/create_term?term=' + term + '&def=' + def, success :function(data) {

                    },error: hideLoadingImage,complete: hideLoadingImage});
                }


            }
        }
    }));

    $('#definition1').live('focusout', (function(e)
    {
        if (($('#term1').attr("value") != "<< Add term") && $('#term1').attr("value") != "" && $('#definition1').attr("value") != "<< Add definition" && $('#definition1').attr("value") != "")
        {

            var term = $('#term1').attr("value")
            var def = $('#definition1').attr("value")
            $("#loading").show();
            jQuery.ajax({url:'/definitions/create_term?term=' + term + '&def=' + def, success :function(data) {

            },error: hideLoadingImage,complete: hideLoadingImage});
        }
        else if ($('#term1').attr("value") != "<< Add term" || $('#term1').attr("value") != "")
        {
            $('#term1').focus();
            flag_def = "true"
            $('#term1').attr("value", "");
            e.preventDefault();
        }

    }));

    $("#add_definition a[id*=edit_def_]").live('click', function(e)
    {

        input_id = $(this).attr('id');
        b = input_id.split("edit_def_")[1]
        $("#term_" + b).attr('readonly', false);
        $("#definition_" + b).attr('readonly', false);
        $("#save_def_" + b).show();
        $("#edit_def_" + b).hide();
        //$("#save_def1_" + b).hide();

    });

    $("#add_definition a[id*=cancel_def_]").live('click', function(e)
    {

        input_id = $(this).attr('id');
        b = input_id.split("cancel_def_")[1]
        $("#save_def_" + b).hide();
        $("#save_def1_" + b).show();
        $("#edit_def_" + b).show();

    });
    $("#add_file_name a[id*=edit_file_]").live('click', function(e)
    {

        input_id = $(this).attr('id');
        b = input_id.split("edit_file_")[1]
        $("#save_file_" + b).show();
        $("#edit_file_" + b).hide();

    });
    $("#add_file_name a[id*=cancel_file_]").live('click', function(e)
    {

        input_id = $(this).attr('id');
        b = input_id.split("cancel_file_")[1]
        $("#save_file_" + b).hide();
        $("#edit_file_" + b).show();

    });
    $('textarea[id*=file_comment_]').live('click', (function(e)
    {
        input_id = $(this).attr('id');
        id = input_id.split("file_comment_")[1]
        if ($(this).attr("value") == "<< Add comment")
        {
             $(this).removeClass("inpTxt rgt w400px");
            $(this).addClass("inpTxt lft w400px");
            $(this).attr("value", "");
            $(this).focus();
            e.preventDefault();

        }


    }));


    $('textarea[id*=file_comment_]').live('focusout', (function(e)
    {
        input_id = $(this).attr('id');
        id = input_id.split("file_comment_")[1]
        var comment = $(this).attr("value")
        if ($.trim(comment)!="")
        {
        jQuery.ajax({url:'/project_files/create_comment?comment=' + comment + '&id=' + id, success :function(data) {

        }})
        }    

    }));

    $('textarea[id*=file_comment_]').live('keypress', (function(e)
    {
        input_id = $(this).attr('id');
        id = input_id.split("file_comment_")[1]
        if ($(this).attr("value") != "<< Add comment")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var comment = $(this).attr("value")
                 if ($.trim(comment)!="")
                {
                jQuery.ajax({url:'/project_files/create_comment?comment=' + comment + '&id=' + id, success :function(data) {

                }})
                }
            }


        }
    }));
    $("#project_file_file").live('click', function(e)
    {
        $("#file_form").show();


    });
    $("#cancel_file_form").live('click', function(e)
    {
        $("#project_file_file").attr("value", "");
        $("#file_form").hide();


    });
    //Link a file to a requirement 
    $('#add_req_file1').live('click', (function(e)
    {

        if ($(this).attr("value") == "<< Link a file to requirement")
        {

            $(this).attr("value", "");
            $(this).focus();
            e.preventDefault();

        }


    }));


    $("#add_req_file1").keyup(function(e) {
        var match_char = $("#add_req_file1").val();
        if (match_char != "" && e.which != 13 && e.which != 9) {
            $.ajax({
                url:"/project_files/match_file_name/" + match_char,
                success:function(data) {
                    var obj = $.parseJSON(data);
                    var testSuggest = '';
                    testSuggest += '<ul>';
                    for (key in obj) {
                        testSuggest += '<li>' + obj[key].project_file.file_file_name + '</li>';
                    }
                    testSuggest += '</ul>';
                    $('#match_file1').html(testSuggest);
                }
            });
        }
        $('#match_file1').show();

    });

    $('#match_file1 ul li').live('click', function(e) {
        $('#add_req_file1').focus();
        $("#add_req_file1").val($(this).text());
        $('#match_file1').hide();
    });

    $('#add_req_file1').focusout(function(e)
    {
        var file_name = $('#add_req_file1').attr("value")
        var file_name1 = file_name.split(".")[0]
        var ext1 = file_name.split(".")[1]
        if ((ext1 != null) && (file_name1 !== ""))
        {
            jQuery.ajax({url:'/project_files/create_link_req/' + file_name1 + '/' + ext1, success :function(data) {

            }})
        }

    });

    $('#add_req_file1').keypress(function(e)
    {
        if ($('#add_req_file1').attr("value") != "<< Link a file to requirement")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var file_name = $('#add_req_file1').attr("value")
                var file_name1 = file_name.split(".")[0]
                var ext1 = file_name.split(".")[1]
                if ((ext1 != null) && (file_name1 !== ""))
                {
                    jQuery.ajax({url:'/project_files/create_link_req/' + file_name1 + '/' + ext1, success :function(data) {

                    }})
                }

            }


        }
    });


    //Link a file to a usecase
    $('#add_use_file1').live('click', (function(e)
    {

        if ($(this).attr("value") == "<< Link a file to usecase")
        {

            $(this).attr("value", "");
            $(this).focus();
            e.preventDefault();

        }


    }));


    $("#add_use_file1").keyup(function(e) {
        var match_char = $("#add_use_file1").val();
        if (e.which == 13 || e.which == 9) {
            $('#match_file1').hide();
        }
        else
        {
            if (match_char != "") {
                $.ajax({
                    url:"/project_files/match_file_name/" + match_char,
                    success:function(data) {
                        var obj = $.parseJSON(data);
                        var testSuggest = '';
                        testSuggest += '<ul>';
                        for (key in obj) {
                            testSuggest += '<li>' + obj[key].project_file.file_file_name + '</li>';
                        }
                        testSuggest += '</ul>';
                        $('#match_file1').html(testSuggest);
                    }
                });
            }
            $('#match_file1').show();
        }
    });

    $('#match_file1 ul li').live('click', function(e) {
        $("#add_use_file1").focus();
        $("#add_use_file1").val($(this).text());
        $('#match_file1').hide();
    });

    $('#add_use_file1').focusout(function(e)
    {
        var file_name = $('#add_use_file1').attr("value")
        var file_name1 = file_name.split(".")[0]
        var ext1 = file_name.split(".")[1]
        if ((ext1 != null) && (file_name1 !== ""))
        {
            jQuery.ajax({url:'/project_files/create_link_use/' + file_name1 + '/' + ext1, success :function(data) {

            }})
        }

    });

    $('#add_use_file1').keypress(function(e)
    {
        if ($('#add_use_file1').attr("value") != "<< Link a file to usecase")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var file_name = $('#add_use_file1').attr("value")
                var file_name1 = file_name.split(".")[0]
                var ext1 = file_name.split(".")[1]
                if ((ext1 != null) && (file_name1 !== ""))
                {
                    jQuery.ajax({url:'/project_files/create_link_use/' + file_name1 + '/' + ext1, success :function(data) {

                    }})
                }

            }


        }
    });


    //sort requirement,usecases,tracker,definition,project
    $('#sort_req input').live('click', (function(e)
    {
        input_id = $(this).attr('id');
        var sort = input_id.split("sort_")[1]
        jQuery.ajax({url:'/requirements/sort_requirement/' + sort , success :function(data) {

        }})

    }));

    $('#sort_use input').live('click', (function(e)
    {
        input_id = $(this).attr('id');
        var sort = input_id.split("sort_")[1]
        jQuery.ajax({url:'/use_cases/sort_usecase/' + sort , success :function(data) {

        }})

    }));
    $('#sort_tracker input').live('click', (function(e)
    {
        input_id = $(this).attr('id');
        var sort = input_id.split("sort_")[1]
        jQuery.ajax({url:'/trackers/sort_tracker/' + sort , success :function(data) {

        }})

    }));
    $('#sort_definition input').live('click', (function(e)
    {
        input_id = $(this).attr('id');
        var sort = input_id.split("sort_")[1]
        jQuery.ajax({url:'/definitions/sort_def/' + sort , success :function(data) {

        }})

    }));
    $('#sort_file input').live('click', (function(e)
    {
        input_id = $(this).attr('id');
        var sort = input_id.split("sort_")[1]
        jQuery.ajax({url:'/project_files/sort_file/' + sort , success :function(data) {

        }})

    }));
    $("#alphabetic a[id*=alpha]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        def = input_id.split("alpha_")[1]


        jQuery.ajax({url:'/definitions/search_def/' + def , success :function(data) {

        }})


    });


    $('#search_text').click(function(e)
    {
        if ($('#search_text').attr("value") == "Search")
        {
            $(this).attr("value", "");
            $('#search_text').focus();
            e.preventDefault();

        }


    });


    $('#search_help').click(function(e)
    {
        if ($('#search_help').attr("value") == "<< Search for help")
        {
            $('#search_help').removeClass("inpTxt_ad rgt w400px");
            $('#search_help').addClass("inpTxt_ad lft w400px");
            $(this).attr("value", "");
            $('#search_help').focus();
            e.preventDefault();

        }


    });


    $('#search_help').focusout(function(e)
    {
        var msg = $('#search_help').attr("value")
        if ($('#search_help').attr("value") != "<< Search for help" && $('#search_help').attr("value") != "")
        {
        $("#loading").show();
        jQuery.ajax({url:'/homes/search_help/' + msg, success :function(data) {

        },error: hideLoadingImage,complete: hideLoadingImage})
        }
    });

    $('#search_help').keypress(function(e)
    {
        if ($('#search_help').attr("value") != "<< Search for help" && $('#search_help').attr("value") != "")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var msg = $('#search_help').attr("value")
                $("#loading").show();
                jQuery.ajax({url:'/homes/search_help/' + msg, success :function(data) {
                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });
    $("#FAQ a[id*=faq_]").live('click', function(e)
    {

        input_id = $(this).attr('id');
        b = input_id.split("faq_")[1]
        if ($("#faq_answer_" + b).css("display") == "" || $("#faq_answer_" + b).css("display") == "block")
        {
            $("[id*=faq_answer_]").hide();
            $("#faq_answer_" + b).hide();
            $("#faq_answer_" + b).attr('style') = "display:none"

        }
        else
        {
            $("[id*=faq_answer_]").hide();
            $("#faq_answer_" + b).show();
        }

    });
    $("#require a[id*=comment_cancel_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("comment_cancel_")[1];
        $("#comment_show_" + b).find('textarea').attr('readonly', true);
        $("#comment_save_" + b).hide();
        $("#comment_cancel_" + b).hide();


    });
    $("#tracker a[id*=comment_cancel_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("comment_cancel_")[1];
        $("#comment_show_" + b).find('textarea').attr('readonly', true);
        $("#comment_save_" + b).hide();
        $("#comment_cancel_" + b).hide();


    });

    $('#file_requirement').click(function(e)
    {
        if ($('#file_requirement').attr("value") == "<< Start typing to search for a requirement to link")
        {
            $('#file_requirement').removeClass("inpTxt_ad rgt w450px");
            $('#file_requirement').addClass("inpTxt_ad lft w450px");
            $(this).attr("value", "");
            $('#file_requirement').focus();
            e.preventDefault();

        }


    });

    $("#file_requirement").live('keyup', (function(e) {


        if ((e.which === 13) || (e.which === 9))
        {
            $('#match_req_use').hide();
        }
        else
        {
            var match_char = $("#file_requirement").val();
            if (match_char != "") {
                $.ajax({
                    url:"/requirements/match_requirement_name/" + match_char,
                    success:function(data) {
                        var obj = $.parseJSON(data);
                        var testSuggest = '';
                        testSuggest += '<ul>';
                        for (key in obj) {
                            testSuggest += '<li>' + obj[key].requirement.name + '</li>';
                        }
                        testSuggest += '</ul>';
                        $('#match_req_usecase').html(testSuggest);
                    }
                });
            }
            $('#match_req_usecase').show();
        }
    }));


    $('#match_req_usecase ul li').live('click', function(e) {
        $('#file_requirement').focus();
        $("#file_requirement").val($(this).text());
        $('#match_req_usecase').hide();
        flag_req_file = "true"
    });

    $('#file_requirement').focusout(function(e)
    {
        var requirement = jQuery.makeArray($('#file_requirement').attr("value"));
        if (flag_req_file == "true" && requirement != "")
        {
            $("#loading").show();
            jQuery.ajax({url:'/requirements/create_requirement_file?requirement=' + requirement, success :function(data) {
                flag_req_use = "false"
            },error: hideLoadingImage,complete: hideLoadingImage})
        }

    });

    $('#file_requirement').keypress(function(e)
    {
        if ($('#file_requirement').attr("value") != "<< Start typing to search for a requirement to link" && $('#file_requirement').attr("value")!="")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var requirement = jQuery.makeArray($('#file_requirement').attr("value"));
                $("#loading").show();
                jQuery.ajax({url:'/requirements/create_requirement_file?requirement=' + requirement, success :function(data) {

                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });

    $('#file_usecase').click(function(e)
    {
        if ($('#file_usecase').attr("value") == "<< Start typing to search for a use case to link")
        {
            $('#file_usecase').removeClass("inpTxt_ad rgt w450px");
            $('#file_usecase').addClass("inpTxt_ad lft w450px");
            $(this).attr("value", "");
            $('#file_usecase').focus();
            e.preventDefault();

        }


    });

    $("#file_usecase").live('keyup', (function(e) {


        if ((e.which === 13) || (e.which === 9))
        {
            $('#match_req_use').hide();
        }
        else
        {
            var match_char = $("#file_usecase").val();
            if (match_char != "") {
                $.ajax({
                    url:"/use_cases/match_usecase_name/" + match_char,
                    success:function(data) {
                        var obj = $.parseJSON(data);
                        var testSuggest = '';
                        testSuggest += '<ul>';
                        for (key in obj) {
                            testSuggest += '<li>' + obj[key].use_case.name + '</li>';
                        }
                        testSuggest += '</ul>';
                        $('#match_req_usecase').html(testSuggest);
                    }
                });
            }
            $('#match_req_usecase').show();
        }
    }));


    $('#match_req_usecase ul li').live('click', function(e) {
        $('#file_usecase').focus();
        $("#file_usecase").val($(this).text());
        $('#match_req_usecase').hide();
        flag_use_file = "true"
    });

    $('#file_usecase').focusout(function(e)
    {
        var usecase = jQuery.makeArray($('#file_usecase').attr("value"));
        if (flag_use_file == "true" && usecase != "")
        {
            $("#loading").show();
            jQuery.ajax({url:'/use_cases/create_usecase_file?usecase=' + usecase, success :function(data) {
                flag_use_file = "false"
            },error: hideLoadingImage,complete: hideLoadingImage})
        }

    });

    $('#file_usecase').keypress(function(e)
    {
        if ($('#file_usecase').attr("value") != "<< Start typing to search for a use case to link" && $('#file_usecase').attr("value") !="")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var usecase = jQuery.makeArray($('#file_usecase').attr("value"));
                $("#loading").show();
                jQuery.ajax({url:'/use_cases/create_usecase_file?usecase=' + usecase, success :function(data) {

                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });


    $(".sortable").sortable({
    }).disableSelection();

    $('span[id*=step_]').live('mouseup', function() {
        var that = $(this).parent().parent().parent()
        // var cnt = $(this).parent().parent().parent().children().length;
        //alert(that);

        setTimeout(function() {
            cnt = that.children().length;
            //  alert(cnt);
            for (i = 0; i < cnt; i++)
            {
                var id2 = that.children().eq(i).attr("id").split("_")[1];
                var seq = i + 1;

                $('#step_' + id2).html('<a href="#"> Step ' + seq + '</a>');
                jQuery.ajax({url:"/use_case_details/seq_change/" + seq + "/" + id2, success :function(data) {

                }})
            }
        }, 100);
    });

    $('span[id*=step1_alter_]').live('mouseup', function() {
        var that = $(this).parent().parent();
        var cnt = $(this).parent().parent().children().length;
        //alert(cnt+":count");
        setTimeout(function() {
            cnt = that.children().length;
            //cnt = $(this).parent().children().length;
            //alert(cnt+":count after some time");
            for (i = 0; i < cnt; i++)
            {
                var id2 = that.children().eq(i).attr("id").split("_")[1];
                var seq = i + 1;
                $('#step1_alter_' + id2).html('<a href="#"> Step ' + seq + '</a>');
                jQuery.ajax({url:"/use_case_details/seq_change1/" + seq + "/" + id2, success :function(data) {

                }})
            }
        }, 100);
    });

    $('#category_name').click(function(e)
    {
        if (($('#category_name').attr("value") == "<< Add new category") && $('#category_name').attr("value")!="")
        {
            $(this).attr("value", "");
            $('#category_name').removeClass("inpTxt_ad rgt w300px");
            $('#category_name').addClass("inpTxt_ad lft w300px");
            $('#category_name').focus();
            e.preventDefault();

        }


    });


    $('#category_name').focusout(function(e)
    {
        if (($('#category_name').attr("value") != "<< Add new category") && $('#category_name').attr("value")!="")
        {
            var name = $('#category_name').attr("value")
            $("#loading").show();
            jQuery.ajax({url:'/homes/create_category/' + name, success :function(data) {

            },error: hideLoadingImage,complete: hideLoadingImage})
        }

    });

    $('#category_name').keypress(function(e)
    {
        if (($('#category_name').attr("value") != "<< Add new category") &&  $('#category_name').attr("value")!="")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var name = $('#category_name').attr("value")
                $("#loading").show();
                jQuery.ajax({url:'/homes/create_category/' + name, success :function(data) {

                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });

    $("#show_category input[id*=category_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("category_")[1];
        $("#category_save_" + b).show();


    });

    $("#show_category a[id*=category_cancel]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("category_cancel_")[1];
        $("#category_save_" + b).hide();


    });

    $('#delivery_name').click(function(e)
    {
        if ($('#delivery_name').attr("value") == "<< Add new delivery period")
        {
            $(this).attr("value", "");
            $('#delivery_name').removeClass("inpTxt_ad rgt w300px");
            $('#delivery_name').addClass("inpTxt_ad lft w300px");
            $('#delivery_name').focus();
            e.preventDefault();

        }


    });


    $('#delivery_name').focusout(function(e)
    {
        if ($('#delivery_name').attr("value") != "<< Add new delivery period" && $('#delivery_name').attr("value") != "")
        {
            var name = $('#delivery_name').attr("value")
            $("#loading1").show();
            jQuery.ajax({url:'/homes/create_delivery/' + name, success :function(data) {

            },error: hideLoadingImage,complete: hideLoadingImage})
        }

    });

    $('#delivery_name').keypress(function(e)
    {
        if ($('#delivery_name').attr("value") != "<< Add new delivery period" && $('#delivery_name').attr("value") != "")
        {
            if (e.which === 13 || e.which === 9) { // if is enter or tab
                var name = $('#delivery_name').attr("value")
                $("#loading1").show();
                jQuery.ajax({url:'/homes/create_delivery/' + name, success :function(data) {

                },error: hideLoadingImage,complete: hideLoadingImage})

            }


        }
    });

    $("#show_delivery input[id*=delivery_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("delivery_")[1];
        $("#delivery_save_" + b).show();


    });

    $("#show_delivery a[id*=delivery_cancel]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("delivery_cancel_")[1];
        $("#delivery_save_" + b).hide();


    });

    $("#notification input[id*=msg_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        if ($(this).attr('checked'))
        {
            b = input_id.split("msg_")[1];
            jQuery.ajax({url:'/homes/dismiss_notification/' + b, success :function(data) {

            }})
        }

    });
    $("#tracker input[id*=tracker_flag_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        if ($(this).attr('checked'))
        {
            b = input_id.split("tracker_flag_")[1];
            jQuery.ajax({url:'/homes/complete_due_tracker/' + b, success :function(data) {

            }})
        }

    });
    $("#tracker img[id*=tracker_image_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("tracker_image_")[1];
        jQuery.ajax({url:'/homes/delete_tracker/' + b, success :function(data) {

        }})


    });

    $("#assigned_tracker input[id*=tracker_assigned_flag_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("tracker_assigned_flag_")[1];
        jQuery.ajax({url:'/homes/complete_assigned_tracker/' + b, success :function(data) {

        }})


    });
    $("#assigned_tracker img[id*=tracker_image_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("tracker_image_")[1];
        jQuery.ajax({url:'/homes/delete_assigned_tracker/' + b, success :function(data) {

        }})
    });
    $("#add_member input[id*=first_name_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("first_name_")[1];
        $("#member_edit_" + b).show();
    });

    $("#add_member input[id*=last_name_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("last_name_")[1];
        $("#member_edit_" + b).show();
    });
    $("#add_member input[id*=email_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("email_")[1];
        $("#member_edit_" + b).show();
    });
    $("#add_member select[id*=privilige_]").live('change', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("privilige_")[1];
        c = b.split("_")[0];
        $("#member_edit_" + c).show();
    });
    $("#add_member a[id*=member_cancel_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("member_cancel_")[1];
        $("#member_edit_" + b).hide();
    });

    /* create project*/
    $("#show_project input[id*=project_name_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("project_name_")[1];
        $("#save_cancel_" + b).show();
    });

    $("#show_project input[id*=project_description_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("project_description_")[1];
        $("#save_cancel_" + b).show();
    });
    $("#show_project a[id*=cancel_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("cancel_")[1];
        $("#save_cancel_" + b).hide();
    });

    $("#definition textarea[id*=term_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("term_")[1]
        $("#save_def_" + b).show();

    });

    $("#definition textarea[id*=definition_]").live('click', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("definition_")[1]
        $("#save_def_" + b).show();

    });

    $("#definition textarea[id*=term_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("term_")[1]
        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        $("#definition_" + b).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#definition textarea[id*=term_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("term_")[1]
        $(this).css("background", "#fff");
        $("#definition_" + b).css("background", "#fff");
        //$(this).focusout();


    });

    $("#definition textarea[id*=definition_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("definition_")[1]
        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        $("#term_" + b).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#definition textarea[id*=definition_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("definition_")[1]
        $(this).css("background", "#fff");
        $("#term_" + b).css("background", "#fff");
        //$(this).focusout();


    });

    $("#show_project input[id*=project_name_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("project_name_")[1]

        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        $("#project_description_" + b).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#show_project input[id*=project_name_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("project_name_")[1]
        $(this).css("background", "#fff");
        $("#project_description_" + b).css("background", "#fff");
        //$(this).focusout();


    });

    $("#show_project input[id*=project_description_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("project_description_")[1]

        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        $("#project_name_" + b).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#show_project input[id*=project_description_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("project_description_")[1]
        $(this).css("background", "#fff");
        $("#project_name_" + b).css("background", "#fff");
        //$(this).focusout();


    });


    $("#add_member input[id*=first_name_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("first_name_")[1]

        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        $("#last_name_" + b).css("background", "#ffffac");
        $("#email_" + b).css("background", "#ffffac");
        $("#privilige_" + b + "_").css("background", "#ffffac");
        //$(this).focus();


    });

    $("#add_member input[id*=first_name_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("first_name_")[1]
        $(this).css("background", "#fff");
        $("#last_name_" + b).css("background", "#fff");
        $("#email_" + b).css("background", "#fff");
        $("#privilige_" + b + "_").css("background", "#fff");
        //$(this).focusout();


    });

    $("#add_member input[id*=last_name_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("last_name_")[1]

        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        $("#first_name_" + b).css("background", "#ffffac");
        $("#email_" + b).css("background", "#ffffac");
        $("#privilige_" + b + "_").css("background", "#ffffac");
        //$(this).focus();


    });

    $("#add_member input[id*=last_name_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("last_name_")[1]
        $(this).css("background", "#fff");
        $("#first_name_" + b).css("background", "#fff");
        $("#email_" + b).css("background", "#fff");
        $("#privilige_" + b + "_").css("background", "#fff");
        //$(this).focusout();


    });
    $("#add_member input[id*=email_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("email_")[1]

        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        $("#last_name_" + b).css("background", "#ffffac");
        $("#first_name_" + b).css("background", "#ffffac");
        $("#privilige_" + b + "_").css("background", "#ffffac");
        //$(this).focus();


    });

    $("#add_member input[id*=email_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("email_")[1]
        $(this).css("background", "#fff");
        $("#last_name_" + b).css("background", "#fff");
        $("#first_name_" + b).css("background", "#fff");
        $("#privilige_" + b + "_").css("background", "#fff");
        //$(this).focusout();


    });

    $("#add_member select[id*=privilige_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b1 = input_id.split("privilige_")[1]
        b = b1.split("_")[0]
        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        $("#last_name_" + b).css("background", "#ffffac");
        $("#email_" + b).css("background", "#ffffac");
        $("#first_name_" + b).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#add_member select[id*=privilige_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b1 = input_id.split("privilige_")[1]
        b = b1.split("_")[0]
        $(this).css("background", "#fff");
        $("#last_name_" + b).css("background", "#fff");
        $("#email_" + b).css("background", "#fff");
        $("#first_name_" + b).css("background", "#fff");
        //$(this).focusout();


    });


    $("#show_category input[id*=category_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("category_")[1]

        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#show_category input[id*=category_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("category_")[1]
        $(this).css("background", "#fff");
        //$(this).focusout();


    });

    $("#show_delivery input[id*=delivery_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("delivery_")[1]

        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#show_delivery input[id*=delivery_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("delivery_")[1]
        $(this).css("background", "#fff");
        //$(this).focusout();


    });

    $("#add_use_case_detail textarea[id*=basic_action_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("basic_action_")[1];
        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        $("#basic_response_" + b).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#add_use_case_detail textarea[id*=basic_action_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("basic_action_")[1];
        $(this).css("background", "#fff");
        $("#basic_response_" + b).css("background", "#fff");
        //$(this).focusout();


    });
    $("#add_use_case_detail textarea[id*=basic_response_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("basic_response_")[1];
        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        $("#basic_action_" + b).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#add_use_case_detail textarea[id*=basic_response_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("basic_response_")[1];
        $(this).css("background", "#fff");
        $("#basic_action_" + b).css("background", "#fff");
        //$(this).focusout();


    });

    $("#add_use_case_detail1 input[id*=alternate_flow_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("alternate_flow_")[1];
        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");

        //$(this).focus();


    });

    $("#add_use_case_detail1 input[id*=alternate_flow_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("alternate_flow_")[1];
        $(this).css("background", "#fff");
        //$(this).focusout();


    });


    $("#add_use_case_detail1 textarea[id*=alter_basic_action_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("alter_basic_action_")[1];
        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        $("#alter_basic_response_" + b).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#add_use_case_detail1 textarea[id*=alter_basic_action_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("alter_basic_action_")[1];
        $(this).css("background", "#fff");
        $("#alter_basic_response_" + b).css("background", "#fff");
        //$(this).focusout();


    });

    $("#add_use_case_detail1 textarea[id*=alter_basic_response_]").live('mouseover', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("alter_basic_response_")[1];
        $(this).css('cursor', 'pointer');
        $(this).css("background", "#ffffac");
        $("#alter_basic_action_" + b).css("background", "#ffffac");
        //$(this).focus();


    });

    $("#add_use_case_detail1 textarea[id*=alter_basic_response_]").live('mouseout', function(e)
    {
        input_id = $(this).attr('id');
        b = input_id.split("alter_basic_response_")[1];
        $(this).css("background", "#fff");
        $("#alter_basic_action_" + b).css("background", "#fff");
        //$(this).focusout();


    });

    $('#add_use_case_detail1 a[id*=save_alter_basic_flow1_]').live('click', (function(e)
    {
        input_id = $(this).attr('id');
        var id = input_id.split("save_alter_basic_flow1_")[1]
        var action1 = $("#alter_basic_action_" + id).attr('value');
        var response1 = $("#alter_basic_response_" + id).attr('value');

        jQuery.ajax({url:"/use_case_details/edit_alter_basic_flow/" + id + "/" + action1 + "/" + response1, success :function(data) {

        }})

    }));

    $("div[id*=span_images_]").live('mouseenter', function(e)
    {
        input_id = $(this).attr('id');
        var id = input_id.split("span_images_")[1]
        //alert(id);
        $("#delete_images_"+ id).show();
        $("#edit_images_"+ id).show();
        $("#link_images_"+ id).show();
        $("#tracker_images_"+ id).show();
        $("#comment_images_"+ id).show();
        $("#upload_images_"+ id).show();
        


    });

    $("div[id*=span_images_]").live('mouseout', function(e)
    {
       input_id = $(this).attr('id');
       var id = input_id.split("span_images_")[1]

        $("#delete_images_"+ id).hide();
        $("#edit_images_"+ id).hide();
        $("#link_images_"+ id).hide();
        $("#tracker_images_"+ id).hide();
        $("#comment_images_"+ id).hide();
        $("#upload_images_"+ id).hide();


    });

    $("div[id*=span_images1_]").live('mouseenter', function(e)
        {
            input_id = $(this).attr('id');
            var id = input_id.split("span_images1_")[1]
            //alert(id);
            $("#delete_images_"+ id).show();
            $("#edit_images_"+ id).show();
            $("#link_images_"+ id).show();
            $("#tracker_images_"+ id).show();
            $("#comment_images_"+ id).show();
            $("#upload_images_"+ id).show();
            $("#add_show_icon_images_"+ id).show();
            



        });

        $("div[id*=span_images1_]").live('mouseout', function(e)
        {
           input_id = $(this).attr('id');
           var id = input_id.split("span_images1_")[1]

            $("#delete_images_"+ id).hide();
             $("#edit_images_"+ id).hide();
            $("#link_images_"+ id).hide();
            $("#tracker_images_"+ id).hide();
            $("#comment_images_"+ id).hide();
            $("#upload_images_"+ id).hide();
            $("#add_show_icon_images_"+ id).hide();



        });
    $("div[id*=span_images_use_]").live('mouseenter', function(e)
            {
                input_id = $(this).attr('id');
                var id = input_id.split("span_images_use_")[1]
                //alert(id);
                $("#delete_images_"+ id).show();
                $("#edit_images_"+ id).show();
                $("#link_images_"+ id).show();
                $("#tracker_images_"+ id).show();
                $("#comment_images_"+ id).show();
                $("#upload_images_"+ id).show();
                $("#add_show_icon_images_"+ id).show();




            });

            $("div[id*=span_images_use_]").live('mouseout', function(e)
            {
               input_id = $(this).attr('id');
               var id = input_id.split("span_images_use_")[1]

                $("#delete_images_"+ id).hide();
                 $("#edit_images_"+ id).hide();
                $("#link_images_"+ id).hide();
                $("#tracker_images_"+ id).hide();
                $("#comment_images_"+ id).hide();
                $("#upload_images_"+ id).hide();
                $("#add_show_icon_images_"+ id).hide();



            });


    $("div[id*=span_images_track_]").live('mouseenter', function(e)
        {
            input_id = $(this).attr('id');
            var id = input_id.split("span_images_track_")[1]
            //alert(id);
            $("#delete_images_"+ id).show();
            $("#edit_images_"+ id).show();
            $("#comment_images_"+ id).show();
            $("#link_r_images_"+ id).show();
            $("#link_u_images_"+ id).show();
            $("#track_flag_" + id).show();



        });

        $("div[id*=span_images_track_]").live('mouseout', function(e)
        {
           input_id = $(this).attr('id');
           var id = input_id.split("span_images_track_")[1]

            $("#delete_images_"+ id).hide();
             $("#edit_images_"+ id).hide();
            $("#comment_images_"+ id).hide();
            $("#link_r_images_"+ id).hide();
            $("#link_u_images_"+id).hide();
            $("#track_flag_" + id).hide();


        });

    $("div[id*=span_images_track_use_]").live('mouseenter', function(e)
            {
                input_id = $(this).attr('id');
                var id = input_id.split("span_images_track_use_")[1]
                //alert(id);
                $("#delete_images_"+ id).show();
                $("#edit_images_"+ id).show();
                $("#track_usecase_flag_" + id).show();



            });

            $("div[id*=span_images_track_use_]").live('mouseout', function(e)
            {
               input_id = $(this).attr('id');
               var id = input_id.split("span_images_track_use_")[1]

                $("#delete_images_"+ id).hide();
                 $("#edit_images_"+ id).hide();
                $("#track_usecase_flag_" + id).hide();


            });
    $("div[id*=span_images_track_req_]").live('mouseenter', function(e)
                {
                    input_id = $(this).attr('id');
                    var id = input_id.split("span_images_track_req_")[1]
                    //alert(id);
                    $("#delete_images_"+ id).show();
                    $("#edit_images_"+ id).show();
                    $("#track_req_flag_" + id).show();



                });

                $("div[id*=span_images_track_req_]").live('mouseout', function(e)
                {
                   input_id = $(this).attr('id');
                   var id = input_id.split("span_images_track_req_")[1]

                    $("#delete_images_"+ id).hide();
                     $("#edit_images_"+ id).hide();
                    $("#track_req_flag_" + id).hide();


                });

    $("div[id*=span_images_file_]").live('mouseenter', function(e)
            {
                input_id = $(this).attr('id');
                var id = input_id.split("span_images_file_")[1]
                //alert(id);
                $("#delete_images_"+ id).show();
                $("#edit_images_"+ id).show();
                $("#comment_images_"+ id).show();
                $("#link_r_images_"+ id).show();
                $("#link_u_images_"+ id).show();




            });

            $("div[id*=span_images_file_]").live('mouseout', function(e)
            {
               input_id = $(this).attr('id');
               var id = input_id.split("span_images_file_")[1]

                $("#delete_images_"+ id).hide();
                 $("#edit_images_"+ id).hide();
                $("#comment_images_"+ id).hide();
                $("#link_r_images_"+ id).hide();
                $("#link_u_images_"+id).hide();
                


            });

$('#contact_submit').live('click', (function(e)
    {

        var emailfilter = /^\w+[\+\.\w-]*@([\w-]+\.)*\w+[\w-]*\.([a-z]{2,4}|\d+)$/i;
        var flag = false

            if (($("#contact_email").val() == "") || (emailfilter.test($("#contact_email").val()) == false))
            {
                $("#checkEmail").html("").append("Please enter valid email")
                $('#checkEmail').css({'color':'red'});
                //$("#user_email").focus();
                flag = true

            }
            if (($("#contact_name").val() == "")|| ($('#contact_name').attr("value").length < 2))
            {
                $("#checkName").html("").append("Name must contain at least two characters")
                $('#checkName').css({'color':'red'});
               
                flag = true

            }
            if (($("#contact_query").val() == "") || ($('#contatc_query').attr("value").length < 2))
            {

                $("#checkQuery").html("").append("Comment/query must contain at least two characters")
                $('#checkQuery').css({'color':'red'});

                flag = true
            }
             if ($("select#contact_reason option:selected").text() == "Please select...")
        {

            $("#checkReason").html("").append("You must select a reason from the list")
            $('#checkReason').css({'color':'red'});
            //$('#country_').focus();
            flag = true;
        }
            if (flag == true)
            {
                e.preventDefault();
            }
        }));

       $('#contact_name').focusout(function(e) {
        {
            var contact_name = $("#contact_name").val();
            if ((contact_name == '') || (contact_name.length < 2))
            {
                //$('#first_name').focus();
                $("#checkName").html("").append("Name must contain at least two characters")
                $('#checkName').css({'color':'red'});
                e.preventDefault();
            }
            else
            {
                $("#checkName").html("").append("");
                $("#contact_email").focus();
                e.preventDefault();
            }

        }


    });

    $("#contact_email").focusout(function(e) {

        var contactEmail = $("#contact_email").val();
        var filter = /^\w+[\+\.\w-]*@([\w-]+\.)*\w+[\w-]*\.([a-z]{2,4}|\d+)$/i;
        if ((contactEmail == '') || (filter.test($("#contact_email").val()) == false ))
        {
            $("#checkEmail").html("").append("Please enter a valid email address")
            $('#checkEmail').css({'color':'red'});
            e.preventDefault();
        }
        else
        {
                    $("#checkEmail").html("").append("")
                    $("#contact_reason").focus();
                     e.preventDefault();
                }
            });

    $('select#contact_reason').focusout(function(e) {
            {
                var reason = $("select#contact_reason option:selected").text();
                //alert(country);
                if (reason == 'Please select...')
                {

                    $("#checkReason").html("").append("You must select a reason from the list")
                    $('#checkReason').css({'color':'red'});
                    e.preventDefault();
                }
                else
                {
                    $("#checkReason").html("").append("")
                    $("#contact_query").focus();
                    e.preventDefault();
                }
            }
        });

       $('#contact_query').focusout(function(e) {
        {
            var contact_query = $("#contact_query").val();
            if ((contact_query == '') || (contact_query.length < 2))
            {
                $("#checkQuery").html("").append("Comment/query must contain at least two characters")
                $('#checkQuery').css({'color':'red'});
                e.preventDefault();
            }
            else
            {
                $("#checkQuery").html("").append("");
                e.preventDefault();
            }

        }


    });

    $('#password_email_submit').live('click', (function(e)
    {
        var emailfilter = /^\w+[\+\.\w-]*@([\w-]+\.)*\w+[\w-]*\.([a-z]{2,4}|\d+)$/i;

                    if (($("#forgot_email").val() == "") || (emailfilter.test($("#forgot_email").val()) == false))
                    {
                        $("#checkEmail").html("").append("Please enter valid email address")
                        $('#checkEmail').css({'color':'red'});
                        $("#forgot_email").focus();
                        e.preventDefault();

                    }
               

    }));

   $("#forgot_email").focusout(function(e) {

        var userEmail = $("#forgot_email").val();
        var filter = /^\w+[\+\.\w-]*@([\w-]+\.)*\w+[\w-]*\.([a-z]{2,4}|\d+)$/i;
        if ((userEmail == '') || (filter.test($("#forgot_email").val()) == false ))
        {
            $("#forgot_email").focus();
            $("#checkEmail").html("").append("Please enter a valid email address")
            $('#checkEmail').css({'color':'red'});
            e.preventDefault();
        }
   });



     var css=null;
       var HTML_FILE_URL1 = '/stylesheets/screen.css';
            $.get(HTML_FILE_URL1, function(data) {
            css = data;
         });
        if(css==null)
        {
          var HTML_FILE_URL2 = '/stylesheets/screen.css';
            $.get(HTML_FILE_URL2, function(data) {
            css = data;
         });
        }

      $('#print_button').click(function(e){

        if(css==null)
        {
          var HTML_FILE_URL3 = '/stylesheets/screen.css';
            $.get(HTML_FILE_URL3, function(data) {
            css = data;
         });
        }

        data = $('#mainDiv').html();



                 var mywindow = window.open('', 'body_content_left', 'height=400,width=600,scrollbars=1,menuBar=1');
                 mywindow.document.write('<html><head><title>receipt</title>');
                 mywindow.document.write('<style type="text/css">'+css+'</style>');
                 mywindow.document.write('</head><body><div id="mainDiv">'+data+'</div>');
                 //mywindow.document.write(data);
                 mywindow.document.write('</body></html>');
                 mywindow.document.close();
                 mywindow.print();

          e.preventDefault();
      })

    $('#reset_button').live('click', (function(e)
    {
        var emailfilter = /^\w+[\+\.\w-]*@([\w-]+\.)*\w+[\w-]*\.([a-z]{2,4}|\d+)$/i;

                    if (($("#email").val() == "") || (emailfilter.test($("#email").val()) == false))
                    {
                        $("#checkEmail").html("").append("Please enter valid email address")
                        $('#checkEmail').css({'color':'red'});
                        $("#email").focus();
                        e.preventDefault();

                    }


    }));


$('#help_request_submit').live('click', (function(e)
    {

        var emailfilter = /^\w+[\+\.\w-]*@([\w-]+\.)*\w+[\w-]*\.([a-z]{2,4}|\d+)$/i;
        var flag = false

            if (($("#help_request_sender_email").val() == "") || (emailfilter.test($("#help_request_sender_email").val()) == false))
            {
                $("#checkEmail").html("").append("Please enter a valid email address")
                $('#checkEmail').css({'color':'red'});
                //$("#user_email").focus();
                flag = true

            }
            if (($("#help_request_email_content").val() == "")|| ($('#help_request_email_content').attr("value").length < 2))
            {
                $("#checkContent").html("").append("Please enter message")
                $('#checkContent').css({'color':'red'});

                flag = true

            }
            if (flag == true)
            {
                e.preventDefault();
            }
        }));

       $('#help_request_email_content').focusout(function(e) {
        {
            var contact_name = $("#help_request_email_content").val();
            if ((contact_name == '') || (contact_name.length < 2))
            {
                //$('#first_name').focus();
                $("#checkContent").html("").append("Please enter message")
                $('#checkContent').css({'color':'red'});
                e.preventDefault();
            }
            else
            {
                $("#checkContent").html("").append("");
                e.preventDefault();
            }

        }
       });
  
      $("#help_request_sender_email").focusout(function(e) {

        var userEmail = $("#help_request_sender_email").val();
        var filter = /^\w+[\+\.\w-]*@([\w-]+\.)*\w+[\w-]*\.([a-z]{2,4}|\d+)$/i;
        if ((userEmail == '') || (filter.test($("#help_request_sender_email").val()) == false ))
        {

            $("#checkEmail").html("").append("Please enter a valid email address")
            $('#checkEmail').css({'color':'red'});
            e.preventDefault();
        }
        else
            {
                $("#checkEmail").html("").append("");
                $("#help_request_email_content").focus();
                e.preventDefault();
            }
   });

    $('#requirement_10').live("click",(function(e)
              {
                  for (var i=1; i < 11; i++){
                     if ($("#name_"+ i).attr("value")!="")
                     {
                     for (var j=1; j < 11; j++){
                         if ($("#name_"+ j).attr("value")!="" && (i!=j))
                         {
                           if ($("#name_"+ i).attr("value")== $("#name_"+ j).attr("value"))
                           {
                             $('#flash_error_message').html('').append('<div class="flash_error">The system cannot add duplicate requirements, please re-word your requirement</div>');
                             e.preventDefault();
                           }
                        }
                     }
                  }
                }
              }));

    $("input[id*=name_]").live('focusout', function(e)
    {
      input_id = $(this).attr('id');
      var id = input_id.split("name_")[1]
      var name1 = $("#name_" + id).attr('value');
        if (name1!="")
        {
        jQuery.ajax({ url:"/requirements/match_requirement_name/" + name1,success:function(data) {
           var obj = $.parseJSON(data);
           if (obj!="")
           {
            $('#flash_error_message').html('').append('<div class="flash_error">The system cannot add duplicate requirements, please re-word your requirement</div>');
            $("#name_" + id).focus();   
            e.preventDefault();
           }
           else
           {
            $('#flash_error_message').html('').append('');
            e.preventDefault();   
           }

        }
    });
    }        
    });

//Add category dynamicaly
    $('span[id*=rows_category_]').live('change',function(e){
        value=$(this).children().val();
        if (value=="Create New"){
            $('#category_popup').dialog({height:150,width:300,modal: true});
            $('#category_input').attr('value','');
            $('.ui-dialog-titlebar .ui-widget-header .ui-corner-all .ui-helper-clearfix').css('display','none');
            $('.ui-widget-header .ui-icon,.ui-widget-content .ui-icon ').css('background-image',' none')
            $('.ui-widget-header').css({'background':'none','border':'none'});
           // $('.ui-dialog').css({'opacity':'0.9','border':'2px solid'});
             $('.ui-dialog').append("<img id='preview1' style='position: relative;cursor: pointer; float: right; margin-right: -15px; margin-top: -160px;' src='/images/cross.png'>");

        }
           e.preventDefault();
    });
         $('#preview1').live('click', function() {
             $('.ui-dialog').remove();

            });
        $('#category_button').live('click', function() {
            name=$('#category_input').val();
            if (name!=''){
                 $('.ui-dialog').remove();
                 $('#requirement_category').prepend($('<option></option>').val(name).html(name));
                jQuery.ajax({url:'/homes/create_category/' + name, success :function(data) {

                },error: hideLoadingImage,complete: hideLoadingImage})

               }
                });

      $('#category_button1').live('click', function() {
             name=$('#category_input').val();
             if (name!=''){
                  $('.ui-dialog').remove();
                  $('#use_case_category').prepend($('<option></option>').val(name).html(name));
                 jQuery.ajax({url:'/homes/create_category/' + name, success :function(data) {

                 },error: hideLoadingImage,complete: hideLoadingImage})

                }
          $('#category_input').attr("value",'');
                 });

        $('#cancel_button').live('click', function() {
                     $('.ui-dialog').remove();
                
                    });
//Add delivery period dynamically
    $('span[id*=rows_delivery_]').live('change',function(e){
          //alert("test");
          value=$(this).children().val();
          if (value=="Create New"){
              $('#delivery_popup').dialog({height:150,width:300,modal: true});
              $('#delivery_input').attr('value','');
              $('.ui-dialog-titlebar .ui-widget-header .ui-corner-all .ui-helper-clearfix').css('display','none');
              $('.ui-widget-header .ui-icon,.ui-widget-content .ui-icon ').css('background-image',' none')
              $('.ui-widget-header').css({'background':'none','border':'none'});
             // $('.ui-dialog').css({'opacity':'0.9','border':'2px solid'});
               $('.ui-dialog').append("<img id='preview1' style='position: relative;cursor: pointer; float: right; margin-right: -15px; margin-top: -160px;' src='/images/cross.png'>");

          }
             e.preventDefault();
      });

          $('#delivery_button').live('click', function() {
              name=$('#delivery_input').val();
              if (name!=''){
                   $('.ui-dialog').remove();
                   $('#requirement_delivered').prepend($('<option></option>').val(name).html(name));

                  jQuery.ajax({url:'/homes/create_delivery/' + name, success :function(data) {

                  },error: hideLoadingImage,complete: hideLoadingImage})

                 }
              $('#delivery_input').attr("value",'');
                  });

    $('#delivery_button1').live('click', function() {
        name=$('#delivery_input1').val();
        if (name!=''){
             $('.ui-dialog').remove();
             $('#use_case_delivered').append($('<option></option>').val(name).html(name));

            jQuery.ajax({url:'/homes/create_delivery/' + name, success :function(data) {

            },error: hideLoadingImage,complete: hideLoadingImage})

           }
        $('#delivery_input1').attr("value",'');
            });

//Change content at signup page according to select plan type
    $('select#plan_type_').live('change',function(e){
          //alert("test");

          if ($("select#plan_type_ option:selected").text() == "Project - $19 / Month"){
            $(".paypal").attr('style','display');
            e.preventDefault();
          }
          else
          if ($("select#plan_type_ option:selected").text() == "Program - $29 / Month"){
            $(".paypal").attr('style','display');
            e.preventDefault();
          }
          else if ($("select#plan_type_ option:selected").text() == "Free - $0 / Month")
          {
            $(".paypal").attr('style','display:none');
             e.preventDefault();
          }
        });


});