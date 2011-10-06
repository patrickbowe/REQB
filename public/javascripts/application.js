// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
    var flag_def="false"
    var flag_basic="false"
    var flag_alter="false"
    var flag_req_use="false"
    var flag_req_tracker="false"
    $('#payment_type_').attr('disabled', true)
    $('#plan_type_').attr('disabled', true)
    $('#payment_submit').attr('disabled', true)
    
    $('#payment_check').click(function()
       {
         if ($(this).attr('checked'))
            {
            $('#plan_type_').attr('disabled', false)
            $('#payment_type_').attr('disabled', false)
            $('#name_on_card').attr('disabled', false)
            $('#last_name_on_card').attr('disabled', false)
            $('#card_number').attr('disabled', false)
            $('#date_month').attr('disabled', false)
            $('#date_year').attr('disabled', false)
            $('#ccv_code').attr('disabled', false)    
            }
        else
         {
             $('#plan_type_').attr('disabled', true)
             $('#payment_type_').attr('disabled', true)
             $('#name_on_card').attr('disabled', true)
             $('#last_name_on_card').attr('disabled', true)
             $('#card_number').attr('disabled', true)
             $('#date_month').attr('disabled', true)
             $('#date_year').attr('disabled', true)
             $('#ccv_code').attr('disabled', true)

         }
    });
    $('#accept_check').click(function()
       {
         if ($(this).attr('checked'))
         {
            $('#payment_submit').attr('disabled', false)
         }
         else
         {
             $('#payment_submit').attr('disabled', true)
         }
       });

    $('#payment_submit').click(function(e)
       {
             
         if (($('#first_name').attr("value")=="") || ($('#first_name').attr("value").length < 2))
         {
             $('#first_name').focus();
             $("#first_name_error").html("").append("First name must contain two characters")
             $('#first_name_error').css({'color':'red'});
             e.preventDefault();
         }
         else if (($('#last_name').attr("value")=="") || ($('#last_name').attr("value").length < 2))
         {
             $('#last_name').focus();
             $("#last_name_error").html("").append("Last name must contain two characters")
             $('#last_name_error').css({'color':'red'});
             e.preventDefault();
         }
         else  if (($('#address').attr("value")=="") || ($('#address').attr("value").length < 2))
         {
             $('#address').focus();
             e.preventDefault();
             $("#address_error").html("").append("Billing Address must contain two characters")
             $('#address_error').css({'color':'red'});
         }
         else  if (($('#city').attr("value")=="")  || ($('#city').attr("value").length < 2))
         {

             $("#city_error").html("").append("City must contain two characters")
             $('#city_error').css({'color':'red'});
             $('#city').focus();
             e.preventDefault();
         }
         else  if (($('#zip').attr("value")=="") || ($('#zip').attr("value").length < 2))
         {
             $('#zip').focus();
             e.preventDefault();
             $("#zip_error").html("").append("Zip must contain two characters")
             $('#zip_error').css({'color':'red'});
         }
         //else  if ($('#region').attr("value")=="")
         //{
           //  alert("Please enter region / province");
             //$('#region').focus();
             //e.preventDefault();
        // }
         else  if ($("select#country_ option:selected").text()=="--Select--")
         {

             $("#country_error").html("").append("Please select country")
             $('#country_error').css({'color':'red'});
             $('#country_').focus();
             e.preventDefault();
         }
         else  if (($('#phone').attr("value")=="")  || ($('#phone').attr("value").length < 2))
         {
          $('#phone').focus();
          e.preventDefault();
          $("#phone_error").html("").append("Please enter phone number")
          $('#phone_error').css({'color':'red'});
         }

       });



  $("#project_name_project_id").change(function() {
    var project_id = $('select#project_name_project_id option:selected').val();
      //alert(project_name);
      jQuery.ajax({url:'/projects/update_project_name/'+ project_id, success :function(data){

      }})
    

     });

    $('#req_name').click(function(e)
           {
                if ($('#req_name').attr("value")=="<< Add requirement")
               {
                  $(this).attr("value","");
                  $('#req_name').focus();
                  e.preventDefault();

               }


           });
    

    $('#req_name').focusout(function(e)
       {
              var req_name = $('#req_name').attr("value")
              jQuery.ajax({url:'/requirements/create/'+ req_name, success :function(data){
                   
           }})

       });

    $('#req_name').keypress(function(e)
          {
               if ($('#req_name').attr("value")!="<< Add requirement")
              {
                if (e.which === 13 || e.which === 9) { // if is enter or tab
                 var req_name = $('#req_name').attr("value")
                 jQuery.ajax({url:'/requirements/create/'+ req_name, success :function(data){

              }})

                }


          }
          });

    $('#usecase_requirement').click(function(e)
           {
                if ($('#usecase_requirement').attr("value")=="<< Link use case to a requirement")
               {
                  $(this).attr("value","");
                  $('#usecase_requirement').focus();
                  e.preventDefault();

               }


           });

     $("#usecase_requirement").live('keyup',(function(e) {


        if ((e.which === 13) || (e.which === 9))
        {
         $('#match_req_usecase').hide();
        }
        else
        {
            var match_char = $("#usecase_requirement").val();
        if (match_char != "")   {
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
         flag_req_use="true"
    }) ;

    $('#usecase_requirement').focusout(function(e)
       {
              var requirement = $('#usecase_requirement').attr("value")
              if (flag_req_use=="true" && requirement!="")
              {
              jQuery.ajax({url:'/requirements/create_requirement_use/'+ requirement, success :function(data){
              flag_req_use="false"
           }})
              }
       });

    $('#usecase_requirement').keypress(function(e)
          {
               if ($('#usecase_requirement').attr("value")!="<< Link use case to a requirement")
              {
                if (e.which === 13 || e.which === 9) { // if is enter or tab
                 var requirement = $('#usecase_requirement').attr("value")
                 jQuery.ajax({url:'/requirements/create_requirement_use/'+ requirement, success :function(data){

              }})

                }


          }
          });

     $('#use_case_name').click(function(e)
           {
                if ($('#use_case_name').attr("value")=="<< Add use case")
               {
                  $(this).attr("value","");
                  $('#use_case_name').focus();
                  e.preventDefault();

               }


           });


    $('#use_case_name').focusout(function(e)
       {

              var use_name = $('#use_case_name').attr("value")
              jQuery.ajax({url:'/use_cases/create/'+ use_name, success :function(data){

           }})

       });

    $('#use_case_name').keypress(function(e)
       {
           if ($('#use_case_name').attr("value")!="<< Add use case")
           {
             if (e.which === 13 || e.which === 9) { // if is enter
              var use_name = $('#use_case_name').attr("value")
              jQuery.ajax({url:'/use_cases/create/'+ use_name, success :function(data){

                  // window.location.reload()
           }})

             }


       }
       });
    //Link an use case to requriement
    $('#req_use_case_name').live('click',(function(e)
              {
                   if ($('#req_use_case_name').attr("value")=="<< Link requirement to an use case")
                  {
                     $(this).attr("value","");
                     $('#req_use_case_name').focus();
                     e.preventDefault();

                  }


              }));

       $("#req_use_case_name").live('keyup',(function(e) {
           

        if ((e.which === 13) || (e.which === 9))
        {
         $('#match_req_usecase').hide();    
        }
        else
        {
            var match_char = $("#req_use_case_name").val();
        if (match_char != "")   {
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
         flag_req_use="true"  
    }) ;

       $('#req_use_case_name').live('focusout',(function(e)
          {

                 var use_name = $('#req_use_case_name').attr("value")
                 if (use_name!="" && flag_req_use=="true")
                 {
                 flag_req_use=="false"    
                 jQuery.ajax({url:'/use_cases/req_create/'+ use_name, success :function(data){

              }})
              }
          }));


     $('#req_use_case_name').live('keypress',(function(e)
       {
           
           if ($('#req_use_case_name').attr("value")!="<< Link requirement to an use case")
           {
             if (e.which === 13 || e.which === 9) { // if is enter

              var use_name = $('#req_use_case_name').attr("value")
              $('#match_req_usecase').hide(); 
              if (use_name!="")
              {
              jQuery.ajax({url:'/use_cases/req_create/'+ use_name, success :function(data){

                  // window.location.reload()
           }})

             }
             }

       }
       }));
    //End Link an use case to requirement
     
    $('#project_name1').click(function(e)
       {
           if ($('#project_name1').attr("value")=="<< Add a new project")
           {
             $('#project_name1').val('');
             $('#project_name1').focus();
             e.preventDefault();  
           }


       });

    $('#project_name1').focusout(function(e)
           {
                  var project_name = $('#project_name1').attr("value")
                  jQuery.ajax({url:'/projects/create/'+ project_name, success :function(data){

               }})

           });

        $('#project_name1').keypress(function(e)
              {
                   if ($('#project_name1').attr("value")!="<< Add a new project")
                  {
                    if (e.which === 13 || e.which === 9) { // if is enter or tab
                     var project_name = $('#project_name1').attr("value")
                     jQuery.ajax({url:'/projects/create/'+ project_name, success :function(data){

                  }})

                    }


              }
              });



    $('#project_submit').click(function(e)
     {
           if ($('#project_name1').attr("value")=="")
           {
               alert("Please enter project name");
               $('#project_name1').focus();
               e.preventDefault();
           }
     });


    

    $('#member_submit').click(function(e)
       {

         if ($('#member_password').attr("value")=="")
         {
             alert("Please enter password");
              $('#member_password').focus();
             e.preventDefault();
         }
         else if ($('#member_password_confirmation').attr("value")=="")
         {
             alert("Please enter confirm password");
             $('#member_password_confirmation').focus();
             e.preventDefault();
         }
       });

    function popitup(url) {
	newwindow=window.open(url,'name','height=200,width=150');
	if (window.focus) {newwindow.focus()}
	return false;
     };

    $('#member_name1').click(function(e)
              {
                   if ($('#member_name1').attr("value")=="<< Add new person's email address")
                  {
                     $(this).attr("value","");
                     $('#member_name1').focus();
                     e.preventDefault();

                  }


              });


       $('#member_name1').focusout(function(e)
          {
                 var email = $('#member_name1').attr("value")
                 var member_email1=email.replace(/\./g,'*')
                 jQuery.ajax({url:'/members/create/'+ member_email1, success :function(data){

              }})

          });

       $('#member_name1').keypress(function(e)
             {
                  if ($('#member_name1').attr("value")!="<< Add new person's email address")
                 {
                   if (e.which === 13 || e.which === 9) { // if is enter or tab
                    var email = $('#member_name1').attr("value")
                    var member_email1=email.replace(/\./g,'*')
                    jQuery.ajax({url:'/members/create/' + member_email1, success :function(data){

                 }})

                   }


             }
             });

    
$('#pre_condition').click(function(e)
              {
                   if ($('#pre_condition').attr("value")=="<< Add pre-condition")
                  {
                     $(this).attr("value","");
                     $('#pre_condition').focus();
                     e.preventDefault();

                  }


              });


       $('#pre_condition').focusout(function(e)
          {
                 var pre = $('#pre_condition').attr("value")
                 jQuery.ajax({url:'/use_case_details/create_pre_condition/'+ pre, success :function(data){

              }})

          });

       $('#pre_condition').keypress(function(e)
             {
                  if ($('#pre_condition').attr("value")!="<< Add pre-condition")
                 {
                   if (e.which === 13 || e.which === 9) { // if is enter or tab

                       var pre = $('#pre_condition').attr("value")

                    jQuery.ajax({url:'/use_case_details/create_pre_condition/'+ pre, success :function(data){
                 }})

                   }


             }
             });

    $('#post_condition').click(function(e)
                  {
                       if ($('#post_condition').attr("value")=="<< Add post-condition")
                      {
                         $(this).attr("value","");
                         $('#post_condition').focus();
                         e.preventDefault();

                      }


                  });


           $('#post_condition').focusout(function(e)
              {
                     var post = $('#post_condition').attr("value")
                     jQuery.ajax({url:'/use_case_details/create_post_condition/'+ post, success :function(data){

                  }})

              });

           $('#post_condition').keypress(function(e)
                 {
                      if ($('#post_condition').attr("value")!="<< Add post-condition")
                     {
                       if (e.which === 13 || e.which === 9) { // if is enter or tab
                        var post = $('#post_condition').attr("value")
                        jQuery.ajax({url:'/use_case_details/create_post_condition/'+ post, success :function(data){
                     }})

                       }


                 }
                 });
    $('#succ_condition').click(function(e)
                      {
                           if ($('#succ_condition').attr("value")=="<< Add success condition")
                          {
                             $(this).attr("value","");
                             $('#succ_condition').focus();
                             e.preventDefault();

                          }


                      });


               $('#succ_condition').focusout(function(e)
                  {
                         var succ = $('#succ_condition').attr("value")
                         jQuery.ajax({url:'/use_case_details/create_success_condition/'+ succ, success :function(data){

                      }})

                  });

               $('#succ_condition').keypress(function(e)
                     {
                          if ($('#succ_condition').attr("value")!="<< Add success condition")
                         {
                           if (e.which === 13 || e.which === 9) { // if is enter or tab
                            var succ = $('#succ_condition').attr("value")
                            jQuery.ajax({url:'/use_case_details/create_success_condition/'+ succ, success :function(data){
                         }})

                           }


                     }
                     });
    $('#trigger').click(function(e)
                         {
                              if ($('#trigger').attr("value")=="<< Add trigger")
                             {
                                $(this).attr("value","");
                                $('#trigger').focus();
                                e.preventDefault();

                             }


                         });


                  $('#trigger').focusout(function(e)
                     {
                            var trigger = $('#trigger').attr("value")
                            jQuery.ajax({url:'/use_case_details/create_trigger/'+ trigger, success :function(data){

                         }})

                     });

                  $('#trigger').keypress(function(e)
                        {
                             if ($('#trigger').attr("value")!="<< Add trigger")
                            {
                              if (e.which === 13 || e.which === 9) { // if is enter or tab
                               var trigger = $('#trigger').attr("value")
                               jQuery.ajax({url:'/use_case_details/create_trigger/'+ trigger, success :function(data){
                            }})

                              }


                        }
                        });


                 $('#actor').click(function(e)
                         {
                              if ($('#actor').attr("value")=="<< Add actor")
                             {
                                $(this).attr("value","");
                                $('#actor').focus();
                                e.preventDefault();

                             }


                         });


                $('#actor').focusout(function(e)
                     {
                            var actor = $('#actor').attr("value")
                            jQuery.ajax({url:'/use_case_details/create_actor/'+ actor, success :function(data){
                      }})

                     });

                  $('#actor').keypress(function(e)
                        {
                             if ($('#actor').attr("value")!="")
                            {
                              if (e.which === 13 || e.which === 9) { // if is enter or tab
                               var actor= $('#actor').attr("value")

                               jQuery.ajax({url:'/use_case_details/create_actor/'+ actor, success :function(data){
                            }})

                              }


                        }
                        });
             
                   $('#business_rule').click(function(e)
                             {
                                  if ($('#business_rule').attr("value")=="<< Add business rule")
                                 {
                                    $(this).attr("value","");
                                    $('#business_rule').focus();
                                    e.preventDefault();

                                 }


                             });


                      $('#business_rule').focusout(function(e)
                         {
                                var rule = $('#business_rule').attr("value")
                                jQuery.ajax({url:'/use_case_details/create_business_rule/'+ rule, success :function(data){

                             }})

                         });

                      $('#business_rule').keypress(function(e)
                            {
                                 if ($('#business_rule').attr("value")!="<< Add business rule")
                                {
                                  if (e.which === 13 || e.which === 9) { // if is enter or tab
                                   var rule = $('#business_rule').attr("value")
                                   jQuery.ajax({url:'/use_case_details/create_business_rule/'+ rule, success :function(data){
                                }})

                                  }


                            }
                            });

                       $('#use_message').click(function(e)
                                 {
                                      if ($('#use_message').attr("value")=="<< Add message")
                                     {
                                        $(this).attr("value","");
                                        $('#use_message').focus();
                                        e.preventDefault();

                                     }


                                 });


                          $('#use_message').focusout(function(e)
                             {
                                    var msg = $('#use_message').attr("value")
                                    jQuery.ajax({url:'/use_case_details/create_message/'+ msg, success :function(data){

                                 }})

                             });

                          $('#use_message').keypress(function(e)
                                {
                                     if ($('#use_message').attr("value")!="<< Add message")
                                    {
                                      if (e.which === 13 || e.which === 9) { // if is enter or tab
                                       var msg = $('#use_message').attr("value")
                                       jQuery.ajax({url:'/use_case_details/create_message/'+ msg, success :function(data){
                                    }})

                                      }


                                }
                                });
                      $('#alternate_flow').click(function(e)
                                 {
                                      if ($('#alternate_flow').attr("value")=="<< Add an alternate flow")
                                     {
                                        $(this).attr("value","");
                                        $('#alternate_flow').focus();
                                        e.preventDefault();

                                     }


                                 });


                          $('#alternate_flow').focusout(function(e)
                             {
                                    var title = $('#alternate_flow').attr("value")
                                    jQuery.ajax({url:'/use_case_details/create_alter_flow/'+ title, success :function(data){

                                 }})

                             });

                          $('#alternate_flow').keypress(function(e)
                                {
                                     if ($('#alternate_flow').attr("value")!="<< Add an alternate flow")
                                    {
                                      if (e.which === 13 || e.which === 9) { // if is enter or tab
                                       var title = $('#alternate_flow').attr("value")
                                       jQuery.ajax({url:'/use_case_details/create_alter_flow/'+ title, success :function(data){
                                    }})

                                      }


                                }
                                });



                  $('#use_basic_action').live('click',(function(e)
                                 {
                                      if ($('#use_basic_action').attr("value")=="<< Add an user action")
                                     {
                                        flag_basic="true" 
                                        $(this).attr("value","");
                                        $('#use_basic_action').focus();
                                        e.preventDefault();

                                     }


                                 }));


                               
                              $ ('#use_basic_action').live('keypress',function(e)
                                {
                                    
                                     if ($('#use_basic_action').attr("value")!="<< Add an user action")
                                    {

                                      if (e.which == 13)
                                      {
                                       var action1 = $('#use_basic_action').attr("value");
                                       if (action1!="")
                                       {
                                        jQuery.ajax({url:'/use_case_details/create_basic_flow/'+ action1, success :function(data){
                                       }})
                                       }    
                                      }
                                  }

                                });

                   
                   $('#use_basic_response').live("focusin",function(e)
                                    {
                                         if ($('#use_basic_response').attr("value")=="<< Add an user response")
                                        {
                                           flag_basic="false" 
                                           $(this).attr("value","");
                                           $('#use_basic_response').focus();
                                           e.preventDefault();

                                        }


                                    });

           $('#use_basic_response').focusout(function(e)
                                 {
                                       flag_basic="false"
                                       var action1= $('#use_basic_action').attr("value")
                                       var response1= $('#use_basic_response').attr("value")
                                       if (action1!="" && action1!="<< Add an user action" && response1!="" && response1!="<< Add an user response")
                                       {

                                        jQuery.ajax({url:'/use_case_details/create_basic_flow1/'+ action1 + '/' + response1, success :function(data){
                                         }})
                                       }
                                       else if (action1!="" && action1!="<< Add an user action" && (response1=="" || response1=="<< Add an user response"))
                                       {
                                        jQuery.ajax({url:'/use_case_details/create_basic_flow/'+ action1, success :function(data){
                                       }})
                                       }
                                       else if ((action1=="" || action1=="<< Add an user action") && response1!="" && response1!="<< Add an user response")
                                       {
                                        jQuery.ajax({url:'/use_case_details/create_basic_flow2/'+ response1, success :function(data){
                                       }})
                                       }
                                 });

          $('#use_basic_response').keypress(function(e)
                                {
                                     flag_basic="false"
                                     if ($('#use_basic_response').attr("value")!="<< Add an user response" && $('#use_basic_action').attr("value")!="<< Add an user action")
                                    {
                                      if (e.which === 13 || e.which === 9) { // if is enter or tab
                                       var action1= $('#use_basic_action').attr("value")
                                       var response1= $('#use_basic_response').attr("value")
                                       if ((action1!="") && (response1!=""))
                                       {
                                        
                                        jQuery.ajax({url:'/use_case_details/create_basic_flow1/'+ action1 + '/' + response1, success :function(data){
                                         }})
                                       }
                                       else if ((action1!="") && (response1==""))
                                       {
                                        jQuery.ajax({url:'/use_case_details/create_basic_flow/'+ action1, success :function(data){
                                       }})
                                       }
                                       else if ((action1=="") && (response1!=""))
                                       {
                                        jQuery.ajax({url:'/use_case_details/create_basic_flow2/'+ response1, success :function(data){
                                       }})
                                       }
                                      }


                                }
                                });


                $('#add_alternate textarea[id*=use_alter_basic_action_]').live('click',(function(e)
                                 {
                                      input_id=$(this).attr('id');
                                      b=input_id.split("use_alter_basic_action_")[1]
                                     
                                      if ($('#use_alter_basic_action_' + b).attr("value")=="<< Add an user action")
                                     {
                                        flag_alter="true"
                                        $(this).attr("value","");
                                        $('#use_alter_basic_action_' + b).focus();
                                        e.preventDefault();

                                     }


                                 }));


                              $ ('#add_alternate textarea[id*=use_alter_basic_action_]').live('keypress',(function(e)
                                {
                                     input_id=$(this).attr('id');
                                     b=input_id.split("use_alter_basic_action_")[1]
                                     if ($('#use_alter_basic_action_' + b ).attr("value")!="<< Add an user action")
                                    {
                                      if (e.which == 13) { // if is enter
                                       var action1 = $('#use_alter_basic_action_' + b).attr("value");
                                       if (action1!="")
                                       {
                                        jQuery.ajax({url:'/use_case_details/create_alter_basic_flow/'+ action1 + '/' + b, success :function(data){
                                       }})
                                       }
                                      }
                                      else if (e.which == 9) { // if is tab
                                          $('#use_alter_basic_response_' + b).attr("value","");
                                          $('#use_alter_basic_response_' + b ).focus();
                                          e.preventDefault();
                                          }

                                      }



                                }));

                   $('#add_alternate textarea[id*=use_alter_basic_response_]').live('focusin',(function(e)
                                    {
                                         input_id=$(this).attr('id');
                                         b=input_id.split("use_alter_basic_response_")[1]
                                         flag_alter="false"
                                         if ($('#use_alter_basic_response_'+ b).attr("value")=="<< Add an user response")
                                        {
                                           $(this).attr("value","");
                                           $('#use_alter_basic_response_' + b).focus();
                                           e.preventDefault();

                                        }


                                    }));

           $('#add_alternate textarea[id*=use_alter_basic_response_]').live('focusout',(function(e)
                                 {
                                       input_id=$(this).attr('id');
                                       b=input_id.split("use_alter_basic_response_")[1]
                                       flag_alter="false"
                                       var action1= $('#use_alter_basic_action_' + b).attr("value")
                                       var response1= $('#use_alter_basic_response_' + b).attr("value")
                                       if (action1!="" && action1!="<< Add an user action" && response1!="" && response1!="<< Add an user response")
                                       {

                                        jQuery.ajax({url:'/use_case_details/create_alter_basic_flow1/'+ action1 + '/' + response1 + '/' +  b, success :function(data){
                                         }})
                                       }
                                       else if (action1!="" && action1!="<< Add an user action" && (response1=="" || response1=="<< Add an user response"))
                                       {
                                        jQuery.ajax({url:'/use_case_details/create_alter_basic_flow/'+ action1 + '/' + b, success :function(data){
                                       }})
                                       }
                                       else if ((action1=="" || action1=="<< Add an user action") && response1!="" && response1!="<< Add an user response")
                                       {
                                        jQuery.ajax({url:'/use_case_details/create_alter_basic_flow2/'+ response1 + '/' + b, success :function(data){
                                       }})
                                       }
                                 }));

          $('#add_alternate textarea[id*=use_alter_basic_response_]').live('keypress',(function(e)
                                {
                                     input_id=$(this).attr('id');
                                     b=input_id.split("use_alter_basic_response_")[1]
                                     flag_alter="false"
                                     if ($('#use_alter_basic_response_' + b).attr("value")!="<< Add an user response" && $('#use_alter_basic_action_' + b).attr("value")!="<< Add an user action")
                                    {
                                      if (e.which === 13 || e.which === 9) { // if is enter or tab
                                       var action1= $('#use_alter_basic_action_' + b).attr("value")
                                       var response1= $('#use_alter_basic_response_' + b).attr("value")
                                       if (action1!="" && action1!="<< Add an user action" && response1!="" && response1!="<< Add an user response")
                                       {

                                        jQuery.ajax({url:'/use_case_details/create_alter_basic_flow1/'+ action1 + '/' + response1 + '/' + b, success :function(data){
                                         }})
                                       }
                                       else if (action1!="" && action1!="<< Add an user action" && (response1=="" || response1=="<< Add an user response"))
                                       {
                                        jQuery.ajax({url:'/use_case_details/create_alter_basic_flow/'+ action1 + '/' + b, success :function(data){
                                       }})
                                       }
                                       else if ((action1=="" || action1=="<< Add an user action") && response1!="" && response1!="<< Add an user response")
                                       {
                                        jQuery.ajax({url:'/use_case_details/create_alter_basic_flow2/'+ response1 + '/' + b, success :function(data){
                                       }})
                                       }
                                      }


                                }
                                }));

    $("#add_use_case_detail input[id*=pre_condition_]").live('click',function(e)
    {
        input_id=$(this).attr('id');
        b=input_id.split("pre_condition_")[1]
        $("#show_save_cancel_" + b).show();

    });

    $("#add_use_case_detail input[id*=post_condition_]").live('click',function(e)
    {
        input_id=$(this).attr('id');
        b=input_id.split("post_condition_")[1]
        $("#show_save_cancel_" + b).show();

    });

    $("#add_use_case_detail input[id*=succ_condition_]").live('click',function(e)
        {
            input_id=$(this).attr('id');
            b=input_id.split("succ_condition_")[1]
            $("#show_save_cancel_" + b).show();

        });

    $("#add_use_case_detail input[id*=trigger_]").live('click',function(e)
        {
            input_id=$(this).attr('id');
            b=input_id.split("trigger_")[1]
            $("#show_save_cancel_" + b).show();

        });
    $("#add_use_case_detail input[id*=actor_]").live('click',function(e)
            {
                input_id=$(this).attr('id');
                b=input_id.split("actor_")[1]
                $("#show_save_cancel_" + b).show();

            });
    $("#add_use_case_detail input[id*=business_rule_]").live('click',function(e)
                {
                    input_id=$(this).attr('id');
                    b=input_id.split("business_rule_")[1]
                    $("#show_save_cancel_" + b).show();

                });
    $("#add_use_case_detail input[id*=message_]").live('click',function(e)
                   {
                       input_id=$(this).attr('id');
                       b=input_id.split("message_")[1]
                       $("#show_save_cancel_" + b).show();

                   });

    $("#add_use_case_detail a[id*=add_save_cancel_]").live('click',function(e)
                       {
                           
                           input_id=$(this).attr('id');
                           b=input_id.split("add_save_cancel_")[1]
                           $("#basic_action_" + b).attr('readonly', false);
                           $("#basic_response_" + b).attr('readonly', false);
                           $("#show_save_cancel_" + b).show();
                           $("#add_save_cancel_" + b).hide();

                       });

    $("#add_use_case_detail a[id*=add_save_cancel__hide]").live('click',function(e)
                          {

                              input_id=$(this).attr('id');
                              b=input_id.split("add_save_cancel_hide_")[1]
                              $("#basic_action_" + b).attr('readonly', true);
                              $("#basic_response_" + b).attr('readonly', true);
                              $("#show_save_cancel_" + b).hide();
                              $("#add_save_cancel_" + b).show();

                          });

    $("#add_use_case_detail a[id*=alter_save_cancel_]").live('click',function(e)
                           {

                               input_id=$(this).attr('id');
                               b=input_id.split("alter_save_cancel_")[1]
                               $("#show_alter_" + b).show();
                               $("#edit_alternate_" + b).show();
                               $("#alter_save_cancel_" + b).hide();
                               

                           });
    $("#add_use_case_detail a[id*=alter_hide_save_cancel_]").live('click',function(e)
                               {

                                   input_id=$(this).attr('id');
                                   b=input_id.split("alter_hide_save_cancel_")[1]
                                   $("#show_alter_" + b).hide();
                                   $("#edit_alternate_" + b).hide();
                                   $("#alter_save_cancel_" + b).show();

                               });

    $("#add_use_case_detail a[id*=alter_basic_edit_]").live('click',function(e)
                               {

                                   input_id=$(this).attr('id');
                                   b=input_id.split("alter_basic_edit_")[1]
                                   $("#alter_basic_action_" + b).attr('readonly', false);
                                   $("#alter_basic_response_" + b).attr('readonly', false);
                                   $("#alter_basic_edit_" + b).hide();
                                    $("#show_alter_basic_" + b).show();

                               });
        $("#add_use_case_detail a[id*=alter_basic_hide_]").live('click',function(e)
                                   {

                                       input_id=$(this).attr('id');
                                       b=input_id.split("alter_basic_hide_")[1]
                                       $("#alter_basic_action_" + b).attr('readonly', true);
                                       $("#alter_basic_response_" + b).attr('readonly', true);
                                       $("#alter_basic_save_cancel_" + b).hide();
                                       $("#alter_basic_edit_" + b).show();
                                        $("#show_alter_basic_" + b).hide();


                                   });

    $('#user_submit').live('click',(function(e)
       {

        var emailfilter=/^\w+[\+\.\w-]*@([\w-]+\.)*\w+[\w-]*\.([a-z]{2,4}|\d+)$/i;
        var passwordfilter=/^.*(?=.{8,20})(?=.*\d)(?=.*[a-zA-Z]).*$/i;

        if ($("#user_email").length)
        {
        if (($("#user_email").val()=="")  || (emailfilter.test($("#user_email").val())== false))
        {
            $("#checkEmail").html("").append("Please enter valid email")
            $('#checkEmail').css({'color':'red'});
            $("#user_email").focus();
            e.preventDefault();

        }
        else if (($("#user_password").val()=="") || (passwordfilter.test($("#user_password").val())== false))
           {
                $("#checkPassword").html("").append("Passwords must be at least 8 characters and contains letters and numbers")
                $('#checkPassword').css({'color':'red'});
                $("#user_password").focus();
                e.preventDefault();

           }
        else if   (($("#user_password_confirmation").val()=="") || ($("#user_password_confirmation").val()!=$("#user_password").val()))
        {

               $("#checkPasswordCon").html("").append("Password confirmation should be match")
               $('#checkPasswordCon').css({'color':'red'});
               $("#user_password_confirmation").focus();
               e.preventDefault();
        }
        }
        else
        {
        if (($("#user_old_password").val()==""))
        {
            $("#old_password_error").html("").append("Please enter your current password")
            $('#old_password_error').css({'color':'red'});
            $("#user_old_password").focus();
            e.preventDefault();

        }
        if (($("#user_password").val()=="") || (passwordfilter.test($("#user_password").val())== false))
           {
                $("#checkPassword").html("").append("Passwords must be at least 8 characters and contains letters and numbers")
                $('#checkPassword').css({'color':'red'});
                $("#user_password").focus();
                e.preventDefault();

           }
        else if   (($("#user_password_confirmation").val()=="") || ($("#user_password_confirmation").val()!=$("#user_password").val()))
        {

               $("#checkPasswordCon").html("").append("Password confirmation should be match")
               $('#checkPasswordCon').css({'color':'red'});
               $("#user_password_confirmation").focus();
               e.preventDefault();
        }
        }

       }));
    $("#user_old_password").live('focusout',(function(e){

                 if(($("#user_old_password").val() == ''))
                {
                    $("#user_old_password").focus();
                    $("#old_password_error").html("").append("Passwords must be at least 8 characters and contains letters and numbers")
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



    $("#user_email").focusout(function(e){

         var userEmail = $("#user_email").val();
         var filter=/^\w+[\+\.\w-]*@([\w-]+\.)*\w+[\w-]*\.([a-z]{2,4}|\d+)$/i;
         if((userEmail == '') || (filter.test($("#user_email").val())== false ))
        {
            $("#user_email").focus();
            $("#checkEmail").html("").append("Please enter valid email")
            $('#checkEmail').css({'color':'red'});
            e.preventDefault();
        }
        else
                 {
                   $("#checkEmail").html("").append("")
                   $("#user_password").focus();
                   e.preventDefault();
                 }
    });   
        $("#user_password").live('focusout',(function(e){

                 var userPassword = $("#user_password").val();
                 var filter=/^.*(?=.{8,20})(?=.*\d)(?=.*[a-zA-Z]).*$/i;
                 if((userPassword == '') || (filter.test($("#user_password").val())== false ))
                {
                    $("#user_password").focus();
                    $("#checkPassword").html("").append("Passwords must be at least 8 characters and contains letters and numbers")
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

      $("#user_password_confirmation").live('focusout',(function(e){

                 var userPassword = $("#user_password").val();
                 var userPasswordCon = $("#user_password_confirmation").val();
                 if((userPasswordCon == '') || (userPassword!=userPasswordCon))
                {
                    $("#user_password_confirmation").focus();
                    $("#checkPasswordCon").html("").append("Password confirmation should be match")
                    $('#checkPasswordCon').css({'color':'red'});
                    e.preventDefault();
                }
                else
                 {
                   $("#checkPasswordCon").html("").append("")  
                 }

    }));

    function my_code(){

     $("#first_name").focus();
     $("#user_email").focus();

    }

     window.onload=my_code();
      $('#first_name').focusout(function(e){
            {
                var first_name= $("#first_name").val();
                if((first_name == '') || (first_name.length < 2))
                {
                   $('#first_name').focus(); 
                   $("#first_name_error").html("").append("First name must contain two characters")
                    $('#first_name_error').css({'color':'red'});
                    e.preventDefault();
                }
                else
                 {
                   $("#first_name_error").html("").append("") ;
                   $("#last_name").focus();
                   e.preventDefault();
                 }
                }
            });
    $('#last_name').focusout(function(e){
                   {
                       var last_name= $("#last_name").val();
                       if((last_name == '') || (last_name.length < 2))
                       {
                          $('#last_name').focus();
                          $("#last_name_error").html("").append("Last name must contain two characters")
                           $('#last_name_error').css({'color':'red'});
                           e.preventDefault();
                       }
                       else
                        {
                          $("#last_name_error").html("").append("")
                          $("#address").focus();
                          e.preventDefault();
                        }
                       }
                   });

      $('#address').focusout(function(e){
                {
                    var address= $("#address").val();
                    if((address == '') || (address.length < 2))
                    {
                       $('#address').focus();
                       $("#address_error").html("").append("Billing Address must contain two characters")
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

    $('#city').focusout(function(e){
                       {
                           var city= $("#city").val();
                           if((city == '') || (city.length < 2))
                           {
                              $('#city').focus();
                              $("#city_error").html("").append("City must contain two characters")
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

                  $('#zip').focusout(function(e){
                           {
                               var zip= $("#zip").val();
                               if((zip == '') || (zip.length < 2))
                               {
                                  $('#zip').focus();
                                  $("#zip_error").html("").append("Zip must contain two characters")
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

             $('select#country_').focusout(function(e){
                              {
                                  var country= $("select#country_ option:selected").text();
                                  //alert(country);
                                  if(country == '--Select--')
                                  {

                                     $("#country_error").html("").append("Country must be selected")
                                      $('#country_error').css({'color':'red'});
                                      $(this).focus();
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

                 $('#phone').focusout(function(e){
                                 {
                                     var phone= $("#phone").val();
                                     if(phone == '')
                                     {
                                        $('#phone').focus(); 
                                        $("#phone").html("").append("Please enter phone number")
                                         $('#phone_error').css({'color':'red'});
                                         e.preventDefault();
                                     }
                                     else
                                      {
                                        $("#phone_error").html("").append("")
                                        
                                      }
                                     }
                                 });

    $('#user_session_submit').live('click',(function(e)
           {



            if (($("#user_session_email").val()==""))
            {
                $("#checkEmail").html("").append("Please enter email")
                $('#checkEmail').css({'color':'red'});
                $("#user_session_email").focus();
                e.preventDefault();

            }
            else if (($("#user_session_password").val()==""))
               {
                    $("#checkPassword").html("").append("Please enter password")
                    $('#checkPassword').css({'color':'red'});
                    $("#user_session_password").focus();
                    e.preventDefault();

               }

           }));
        $("#user_session_email").focusout(function(e){

             if (($("#user_session_email").val()==""))
            {
                $("#user_session_email").focus();
                $("#checkEmail").html("").append("Please enter email")
                $('#checkEmail').css({'color':'red'});
                e.preventDefault();
            }
            else
                     {
                       $("#checkEmail").html("").append("")
                       $("#user_session_password").focus();
                       e.preventDefault();
                     }
        });
            $("#user_session_password").live('focusout',(function(e){

                     if (($("#user_session_password").val()==""))
                    {
                        $("#user_session_password").focus();
                        $("#checkPassword").html("").append("Please enter the password")
                        $('#checkPassword').css({'color':'red'});
                        e.preventDefault();
                    }
                    else
                     {
                       $("#checkPassword").html("").append("")
                       
                     }

        }));

    $('#tracker_name').click(function(e)
           {
                if ($('#tracker_name').attr("value")=="<< Add tracker")
               {
                  $(this).attr("value","");
                  $('#tracker_name').focus();
                  e.preventDefault();

               }


           });


    $('#tracker_name').focusout(function(e)
       {
              var tracker_name = $('#tracker_name').attr("value")
              jQuery.ajax({url:'/trackers/create/'+ tracker_name, success :function(data){

           }})

       });

    $('#tracker_name').keypress(function(e)
          {
               if ($('#tracker_name').attr("value")!="<< Add tracker")
              {
                if (e.which === 13 || e.which === 9) { // if is enter or tab
                 var tracker_name = $('#tracker_name').attr("value")
                 jQuery.ajax({url:'/trackers/create/'+ tracker_name, success :function(data){

              }})

                }


          }
          });
    $('#add_tracker input[id*=track_flag_]').live('click',(function(e)
              {
                    input_id=$(this).attr('id');
                    id=input_id.split("track_flag_")[1]
                    if ($(this).attr('checked')){

                     var tracker_flag = $(this).attr("checked")
                     jQuery.ajax({url:'/trackers/tracker_flag/'+ tracker_flag + '/' + id, success :function(data){

                      }})

                  
                    }
                    else
                    {

                    var tracker_flag = $(this).attr("checked")
                    jQuery.ajax({url:'/trackers/tracker_flag/'+ tracker_flag + '/' + id, success :function(data){

                      }})


                    }



              }));
              
    //Link  a tracker to requirement
    $('#tracker_req_name').live('click',(function(e)
           {
                if ($('#tracker_req_name').attr("value")=="<< Link requirement to a tracker")
               {
                  $(this).attr("value","");
                  $('#tracker_req_name').focus();
                  e.preventDefault();

               }


           }));
    $("#tracker_req_name").live('keyup',(function(e) {
            var match_char = $("#tracker_req_name").val();
            if ((e.which === 13) || (e.which === 9))
                {
                 $('#match_req_usecase').hide();
                }
            else
            {
            if (match_char != "") {
                $.ajax({
                    url:"/trackers/match_tracker_name/" + match_char,
                    success:function(data) {
                        var obj = $.parseJSON(data);
                        var testSuggest = '';
                        testSuggest += '<ul>';
                        for (key in obj) {
                            testSuggest += '<li>' + obj[key].tracker.title + '</li>';
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
             $('#tracker_req_name').focus();    
             $("#tracker_req_name").val($(this).text());
             $('#match_req_usecase').hide();
             flag_req_tracker="true"
        }) ;
    

    $('#tracker_req_name').live('focusout',(function(e)
       {
              if (flag_req_tracker=="true")
              {
              var tracker_name = $('#tracker_req_name').attr("value")
              jQuery.ajax({url:'/trackers/create_tracker_req/'+ tracker_name, success :function(data){

           }})
           }
       }));

    $('#tracker_req_name').live('keypress',(function(e)
          {
               if ($('#tracker_req_name').attr("value")!="<< Link requirement to a tracker")
              {
                if (e.which === 13 || e.which === 9) { // if is enter or tab
                 var tracker_name = $('#tracker_req_name').attr("value")
                 jQuery.ajax({url:'/trackers/create_tracker_req/'+ tracker_name, success :function(data){

              }})

                }


          }
          }));

     //End link a tracker to requirement
    $('#tracker_use_name').click(function(e)
           {
                if ($('#tracker_use_name').attr("value")=="<< Link usecase to a tracker")
               {
                  $(this).attr("value","");
                  $('#tracker_use_name').focus();
                  e.preventDefault();

               }


           });

    $("#tracker_use_name").live('keyup',(function(e) {
                var match_char = $("#tracker_use_name").val();
                if ((e.which === 13) || (e.which === 9))
                    {
                     $('#match_req_usecase').hide();
                    }
                else
                {
                if (match_char != "") {
                    $.ajax({
                        url:"/trackers/match_tracker_name/" + match_char,
                        success:function(data) {
                            var obj = $.parseJSON(data);
                            var testSuggest = '';
                            testSuggest += '<ul>';
                            for (key in obj) {
                                testSuggest += '<li>' + obj[key].tracker.title + '</li>';
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
                 $('#tracker_use_name').focus();
                 $("#tracker_use_name").val($(this).text());
                 $('#match_req_usecase').hide();
                 flag_req_tracker="true"
            }) ;

    $('#tracker_use_name').focusout(function(e)
       {
              if (flag_req_tracker=="true")
              {
              var tracker_name = $('#tracker_use_name').attr("value")
              jQuery.ajax({url:'/trackers/create_tracker_use/'+ tracker_name, success :function(data){

           }})
              }
       });

    $('#tracker_use_name').keypress(function(e)
          {
               if ($('#tracker_use_name').attr("value")!="<< Link usecase to a tracker")
              {
                if (e.which === 13 || e.which === 9) { // if is enter or tab
                 var tracker_name = $('#tracker_use_name').attr("value")
                 jQuery.ajax({url:'/trackers/create_tracker_use/'+ tracker_name, success :function(data){

              }})

                }


          }
          });

    $('textarea[id*=req_comment_]').live('click',(function(e)
              {

                  
                  if ($(this).attr("value")=="<< Add comment")
                  {
                     
                     $(this).attr("value","");
                     $(this).focus();
                     e.preventDefault();

                  }


              }));


       $('textarea[id*=req_comment_]').live('focusout',(function(e)
          {

                 //var req_id=$('#req_id').attr("value")
                 input_id=$(this).attr('id');
                 id=input_id.split("req_comment_")[1]
                 var comment = $(this).attr("value")
                 jQuery.ajax({url:'/requirements/create_comment/'+ comment + '/' + id, success :function(data){

              }})

          }));

       $('textarea[id*=req_comment_]').live('keypress',(function(e)
             {


                  if ($(this).attr("value")!="<< Add comment")
                 {
                   if (e.which === 13 || e.which === 9) { // if is enter or tab
                    var comment = $(this).attr("value")
                    input_id=$(this).attr('id');
                    id=input_id.split("req_comment_")[1]
                    jQuery.ajax({url:'/requirements/create_comment/'+ comment + '/' + id, success :function(data){

                 }})

                   }


             }
             }));


      $('textarea[id*=use_comment_]').live('click',(function(e)
              {
                    input_id=$(this).attr('id');
                    id=input_id.split("use_comment_")[1]
                  if ($(this).attr("value")=="<< Add comment")
                  {

                     $(this).attr("value","");
                     $(this).focus();
                     e.preventDefault();

                  }


              }));


       $('textarea[id*=use_comment_]').live('focusout',(function(e)
          {
                 input_id=$(this).attr('id');
                 id=input_id.split("use_comment_")[1]
                 var comment = $(this).attr("value")
                 jQuery.ajax({url:'/use_cases/create_comment/'+ comment + '/' + id, success :function(data){

              }})

          }));

       $('textarea[id*=use_comment_]').live('keypress',(function(e)
             {
                  input_id=$(this).attr('id');
                  id=input_id.split("use_comment_")[1]
                  if ($(this).attr("value")!="<< Add comment")
                 {
                   if (e.which === 13 || e.which === 9) { // if is enter or tab
                    var comment = $(this).attr("value")
                    jQuery.ajax({url:'/use_cases/create_comment/'+ comment + '/' + id, success :function(data){

                 }})

                   }


             }
             }));

    $('textarea[id*=tracker_comment_]').live('click',(function(e)
            {
                  input_id=$(this).attr('id');
                  id=input_id.split("tracker_comment_")[1]
                if ($(this).attr("value")=="<< Add comment")
                {

                   $(this).attr("value","");
                   $(this).focus();
                   e.preventDefault();

                }


            }));


     $('textarea[id*=tracker_comment_]').live('focusout',(function(e)
        {
               input_id=$(this).attr('id');
               id=input_id.split("tracker_comment_")[1]
               var comment = $(this).attr("value")
               jQuery.ajax({url:'/trackers/create_comment/'+ comment + '/' + id, success :function(data){

            }})

        }));

     $('textarea[id*=tracker_comment_]').live('keypress',(function(e)
           {
                input_id=$(this).attr('id');
                id=input_id.split("tracker_comment_")[1]
                if ($(this).attr("value")!="<< Add comment")
               {
                 if (e.which === 13 || e.which === 9) { // if is enter or tab
                  var comment = $(this).attr("value")
                  jQuery.ajax({url:'/trackers/create_comment/'+ comment + '/' + id, success :function(data){

               }})

                 }


           }
           }));

        $('.calendar').live('focusin',function(){
       $(this).datepicker();
    });

     $('#term').live('click',(function(e)
           {
                if ($('#term').attr("value")=="<< Add term")
               {
                  $(this).attr("value","");
                  $('#term').focus();
                  flag_def="true"
                  e.preventDefault();

               }


           }));

     $(document).click(function(e)
     {
         if (($('#term').attr("value")!="<< Add term") && $('#term').attr("value")!="" && flag_def=="true")
              {
                 flag_def="false"
                 var term = $('#term').attr("value")
                 var def = $('#definition').attr("value")
                 jQuery.ajax({url:'/definitions/create_term/'+ term + '/' + def, success :function(data){

            }});
              }
         else if (($('#use_basic_action').attr("value")!="<< Add an user action") && $('#use_basic_action').attr("value")!="" && flag_basic=="true")
         {
                flag_basic="false"
                var action1 = $('#use_basic_action').attr("value");
                jQuery.ajax({url:'/use_case_details/create_basic_flow/'+ action1, success :function(data){
                }})   
         }
         else if (flag_alter=="true")
         {
             input_id=$('#add_alternate textarea[id*=use_alter_basic_action_]').attr('id');
             b=input_id.split("use_alter_basic_action_")[1]
             var action1 = $('#use_alter_basic_action_' + b).attr("value");
             if (action1!="" && action1!="<< Add an user action")
             {
                 flag_alter="false"
                 jQuery.ajax({url:'/use_case_details/create_alter_basic_flow/'+ action1 + '/' + b, success :function(data){
                }})
             }

         }
     });


    $('#term').live ('keypress',(function(e)
          {
              
               if (($('#term').attr("value")!="<< Add term") && $('#term').attr("value")!="")
              {
                if (e.which === 13 || e.which === 9) { // if is enter or tab
                    if ($('#definition').attr("value")=="<< Add definition" || $('#definition').attr("value")=="")
                    {
                        $('#definition').focus();
                      $('#definition').attr("value","");
                      e.preventDefault();
                    }
                    else
                    {
                     var term = $('#term').attr("value")
                     var def = $('#definition').attr("value")
                     jQuery.ajax({url:'/definitions/create_term/'+ term + '/' + def, success :function(data){
                     }});
                     
                    }

                }


          }
          }));

    
       $('#definition').live('focusin',(function(e)
                      {
                           if ($('#definition').attr("value")=="<< Add definition")
                          {
                             flag_def="false" 
                             $(this).attr("value","");
                             $('#definition').focus();
                             e.preventDefault();

                          }


                      }));

    $('#definition').live('click',(function(e)
               {
                    if ($('#definition').attr("value")=="<< Add definition")
                   {
                      $(this).attr("value","");
                      $('#definition').focus();
                      e.preventDefault();

                   }


               }));



        $('#definition').live('keypress',(function(e)
              {

                   if (($('#definition').attr("value")!="<< Add definition") && $('#definition').attr("value")!="")
                  {
                    if (e.which === 13 || e.which===9) { // if is enter or tab
                        
                        if ($('#term').attr("value")=="<< Add term")
                        {
                           $('#term').focus();
                           $('#term').attr("value","");
                           flag_def="true" 
                           e.preventDefault();
                        }
                        else
                        {
                         var term = $('#term').attr("value")
                         var def= $('#definition').attr("value")
                         jQuery.ajax({url:'/definitions/create_term/'+ term + '/' + def, success :function(data){

                         }

                         });
                    }


              }
              }}));

    $('#definition').live('focusout',(function(e)
               {
                      if (($('#term').attr("value")!="<< Add term") && $('#term').attr("value")!="" && $('#definition').attr("value")!="<< Add definition" && $('#definition').attr("value")!="") 
                      {

                         var term = $('#term').attr("value")
                         var def = $('#definition').attr("value")
                         jQuery.ajax({url:'/definitions/create_term/'+ term + '/' + def, success :function(data){

               }});
                      }
               else if ($('#term').attr("value")!="<< Add term" || $('#term').attr("value")!="")
                      {
                          $('#term').focus();
                          flag_def="true"
                          $('#term').attr("value","");
                          e.preventDefault();
                      }

               }));

      $("#add_definition a[id*=edit_def_]").live('click',function(e)
                          {

                              input_id=$(this).attr('id');
                              b=input_id.split("edit_def_")[1]
                              $("#term_" + b).attr('readonly', false);
                              $("#definition_" + b).attr('readonly', false);
                              $("#save_def_" + b).show();
                              $("#edit_def_" + b).hide();

                          });

       $("#add_definition a[id*=cancel_def_]").live('click',function(e)
                             {

                                 input_id=$(this).attr('id');
                                 b=input_id.split("cancel_def_")[1]
                                 $("#save_def_" + b).hide();
                                 $("#edit_def_" + b).show();

                             });
    $("#add_file_name a[id*=edit_file_]").live('click',function(e)
                              {

                                  input_id=$(this).attr('id');
                                  b=input_id.split("edit_file_")[1]
                                  $("#save_file_" + b).show();
                                  $("#edit_file_" + b).hide();

                              });
    $("#add_file_name a[id*=cancel_file_]").live('click',function(e)
                                 {

                                     input_id=$(this).attr('id');
                                     b=input_id.split("cancel_file_")[1]
                                     $("#save_file_" + b).hide();
                                     $("#edit_file_" + b).show();

                                 });
    $('textarea[id*=file_comment_]').live('click',(function(e)
                {
                      input_id=$(this).attr('id');
                      id=input_id.split("file_comment_")[1]
                    if ($(this).attr("value")=="<< Add comment")
                    {

                       $(this).attr("value","");
                       $(this).focus();
                       e.preventDefault();

                    }


                }));


         $('textarea[id*=file_comment_]').live('focusout',(function(e)
            {
                   input_id=$(this).attr('id');
                   id=input_id.split("file_comment_")[1]
                   var comment = $(this).attr("value")
                   jQuery.ajax({url:'/project_files/create_comment/'+ comment + '/' + id, success :function(data){

                }})

            }));

         $('textarea[id*=file_comment_]').live('keypress',(function(e)
               {
                    input_id=$(this).attr('id');
                    id=input_id.split("file_comment_")[1]
                    if ($(this).attr("value")!="<< Add comment")
                   {
                     if (e.which === 13 || e.which === 9) { // if is enter or tab
                      var comment = $(this).attr("value")
                      jQuery.ajax({url:'/project_files/create_comment/'+ comment + '/' + id, success :function(data){

                   }})

                     }


               }
               }));
      $("#project_file_file").live('click',function(e)
                                 {
                                     $("#file_form").show();


                                 });
     $("#cancel_file_form").live('click',function(e)
                                     {
                                         $("#project_file_file").attr("value","");
                                         $("#file_form").hide();



                                     });
    //Link a file to a requirement 
    $('#add_req_file1').live('click',(function(e)
                    {

                        if ($(this).attr("value")=="<< Link a file to requirement")
                        {

                           $(this).attr("value","");
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
    }) ;

  $('#add_req_file1').focusout(function(e)
       {
              var file_name = $('#add_req_file1').attr("value")
                 var file_name1=file_name.split(".")[0]
                 var ext1=file_name.split(".")[1]
              if ((ext1!=null) && (file_name1!==""))
              {
               jQuery.ajax({url:'/project_files/create_link_req/'+ file_name1 + '/' + ext1, success :function(data){

           }})}

       });

    $('#add_req_file1').keypress(function(e)
          {
               if ($('#add_req_file1').attr("value")!="<< Link a file to requirement")
              {
                if (e.which === 13 || e.which === 9) { // if is enter or tab
                 var file_name = $('#add_req_file1').attr("value")
                 var file_name1=file_name.split(".")[0]
                 var ext1=file_name.split(".")[1]
                 if ((ext1!=null) && (file_name1!==""))
                 {
                     jQuery.ajax({url:'/project_files/create_link_req/'+ file_name1 + '/' + ext1, success :function(data){

              }})
                 }

                }


          }
          });


//Link a file to a usecase
    $('#add_use_file1').live('click',(function(e)
                    {

                        if ($(this).attr("value")=="<< Link a file to usecase")
                        {

                           $(this).attr("value","");
                           $(this).focus();
                           e.preventDefault();

                        }


                    }));


     $("#add_use_file1").keyup(function(e) {
        var match_char = $("#add_use_file1").val();
        if (e.which == 13 || e.which == 9){
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
    }) ;

  $('#add_use_file1').focusout(function(e)
       {
              var file_name = $('#add_use_file1').attr("value")
                 var file_name1=file_name.split(".")[0]
                 var ext1=file_name.split(".")[1]
              if ((ext1!=null) && (file_name1!==""))
              {
               jQuery.ajax({url:'/project_files/create_link_use/'+ file_name1 + '/' + ext1, success :function(data){

           }})}

       });

    $('#add_use_file1').keypress(function(e)
          {
               if ($('#add_use_file1').attr("value")!="<< Link a file to usecase")
              {
                if (e.which === 13 || e.which === 9) { // if is enter or tab
                 var file_name = $('#add_use_file1').attr("value")
                 var file_name1=file_name.split(".")[0]
                 var ext1=file_name.split(".")[1]
                 if ((ext1!=null) && (file_name1!==""))
                 {
                     jQuery.ajax({url:'/project_files/create_link_use/'+ file_name1 + '/' + ext1, success :function(data){

              }})
                 }

                }


          }
          });



    //sort requirement,usecases,tracker,definition,project
    $('#sort_req input').live('click',(function(e)
           {
                  input_id=$(this).attr('id');
                  var sort=input_id.split("sort_")[1]
                  jQuery.ajax({url:'/requirements/sort_requirement/'+ sort , success :function(data){

              }})

           }));

    $('#sort_use input').live('click',(function(e)
               {
                      input_id=$(this).attr('id');
                      var sort=input_id.split("sort_")[1]
                      jQuery.ajax({url:'/use_cases/sort_usecase/'+ sort , success :function(data){

                  }})

               }));
    $('#sort_tracker input').live('click',(function(e)
                   {
                          input_id=$(this).attr('id');
                          var sort=input_id.split("sort_")[1]
                          jQuery.ajax({url:'/trackers/sort_tracker/'+ sort , success :function(data){

                      }})

                   }));
    $('#sort_definition input').live('click',(function(e)
                      {
                             input_id=$(this).attr('id');
                             var sort=input_id.split("sort_")[1]
                             jQuery.ajax({url:'/definitions/sort_def/'+ sort , success :function(data){

                         }})

                      }));
    $('#sort_file input').live('click',(function(e)
                          {
                                 input_id=$(this).attr('id');
                                 var sort=input_id.split("sort_")[1]
                                 jQuery.ajax({url:'/project_files/sort_file/'+ sort , success :function(data){

                             }})

                          }));
    $("#alphabetic a[id*=alpha]").live('click',function(e)
                              {
                                  input_id=$(this).attr('id');
                                  def=input_id.split("alpha_")[1]


                                  jQuery.ajax({url:'/definitions/search_def/'+ def , success :function(data){

                                                              }})


                              });
     
    $("#add_definition input[id*=term_]").live('click',function(e)
       {
           input_id=$(this).attr('id');
           $(this).attr('readonly',false);
           b=input_id.split("term_")[1]
           $("#save_def_" + b).show();

       });
     $("#add_definition input[id*=definition_]").live('click',function(e)
       {
           input_id=$(this).attr('id');
           $(this).attr('readonly',false);
           b=input_id.split("definition_")[1]
           $("#save_def_" + b).show();

       });

    $('#search_text').click(function(e)
           {
                if ($('#search_text').attr("value")=="Type Your Text")
               {
                  $(this).attr("value","");
                  $('#search_text').focus();
                  e.preventDefault();

               }


           });

      
       $('#search_help').click(function(e)
                                 {
                                      if ($('#search_help').attr("value")=="<< Search for help")
                                     {
                                        $(this).attr("value","");
                                        $('#search_help').focus();
                                        e.preventDefault();

                                     }


                                 });


                          $('#search_help').focusout(function(e)
                             {
                                    var msg = $('#search_help').attr("value")
                                    jQuery.ajax({url:'/homes/search_help/'+ msg, success :function(data){

                                 }})

                             });

                          $('#search_help').keypress(function(e)
                                {
                                     if ($('#search_help').attr("value")!="<< Search for help")
                                    {
                                      if (e.which === 13 || e.which === 9) { // if is enter or tab
                                       var msg = $('#search_help').attr("value")
                                       jQuery.ajax({url:'/homes/search_help/'+ msg, success :function(data){
                                    }})

                                      }


                                }
                                });
    $("#faq a[id*=faq_]").live('click',function(e)
                                 {
                                     input_id=$(this).attr('id');
                                     b=input_id.split("faq_")[1]
                                     if ($("#faq_answer_"+ b).css("display")=="" || $("#faq_answer_"+ b).css("display") == "block")
                                     {
                                       $("#faq_answer_"+b).hide();
                                       $("#faq_answer_"+ b).attr('style')="display:none"  
                                     }
                                     else
                                     {
                                       $("#faq_answer_"+b).show();
                                     }

                                 });

});