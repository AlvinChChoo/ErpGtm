function OnChange(dropdown)
{
    var e = document.getElementById("text1").value;
    alert(e);
}

function PCMCAccept(idname, postBack)
{
	popUp = window.open('Test111.aspx?formname=' + document.forms[0].name +
		'&id=' + idname + '&postBack=' + postBack,
		'popupcal1',
		'width=165,height=208,left=200,top=250');
}

 function KeyDownHandler1(formName, id, newDate, postBack)
{
	eval('var theform = document.' + formName + ';');
    popUp.close();
    theform.elements[id].value = newDate;

}

function OpenErrorMessage(ID)
{
	popUp = window.open('ErrorMessage.aspx?ID=' + ID ,'popupcal','width=200,height=100,left=200,top=250');
}

function ShowPic(idname)
{
    popUp = window.open('Image.aspx?id=' + idname ,
	'popupcal',
	'width=423,height=300,left=200,top=100');

}

function KeyDownHandler(btn)
    {
        // process only the Enter key
        if (event.keyCode == 13)
        {
            // cancel the default submit
            event.returnValue=false;
            event.cancel = true;
            // submit the form by programmatically clicking the specified button
            btn.click();
        }
    }

function GetFocus(Ctrl)
    {
            Ctrl.focus();
            Ctrl.select();
    }

function GetFocusWhenEnter(Ctrl)
    {
        // process only the Enter key
        if (event.keyCode == 13)
        {
            // cancel the default submit
            event.returnValue=false;
            event.cancel = true;
            // submit the form by programmatically clicking the specified button
            Ctrl.focus();
            Ctrl.select();
        }
    }

function GetFocusWhenEnterWithoutSelect(Ctrl)
    {
        if (event.keyCode == 13)
        {
            event.returnValue=false;
            event.cancel = true;
            Ctrl.focus();
        }
    }

function popUpPage(url)
    {
        pupUp=window.open(url,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=0,width=250,height=250');
    }

function CheckAllDataGridCheckBoxes(aspCheckBoxID, checkVal)
    {
        re = new RegExp(':' + aspCheckBoxID + '$')
            for(i = 0; i < document.forms[0].elements.length; i++)
                {
                    elm = document.forms[0].elements[i]
                    if (elm.type == 'checkbox')
                        {
                            if (re.test(elm.name))
                                {elm.checked = checkVal}
                        }
                }
    }

function CheckAllDataListCheckBoxes(aspCheckBoxID, checkVal)
    {
        re = new RegExp(':' + aspCheckBoxID + '$')
            for(i = 0; i < document.forms[0].elements.length; i++)
                {
                    elm = document.forms[0].elements[i]
                    if (elm.type == 'checkbox')
                        {
                            if (re.test(elm.name))
                                {elm.checked = checkVal}
                        }
                }
    }

function ClearCheckBox(aspCheckBoxID)
    {
        re = new RegExp(':' + aspCheckBoxID + '$')
            for(i = 0; i < document.forms[0].elements.length; i++)
                {
                    elm = document.forms[0].elements[i]
                    if (elm.type == 'checkbox')
                        {
                            if (re.test(elm.name))
                                {elm.checked = false}
                        }
                }
    }


function KeyPress()
{
//alert(window.event.keyCode)
if (window.event.keyCode == 13)
window.event.keyCode =0;
}

function ShowUpActual()
{
    eval('var theForm = ' + document.forms[0].name + ';');
    if (theForm.elements["txtOriUP"].value != null)
        {
            if (theForm.elements["cmbOriCurrCode"].value == 'USD')
                {theForm.elements["txtUP"].value = theForm.elements["txtOriUP"].value*1};

            if (theForm.elements["cmbOriCurrCode"].value == 'JPY')
                {theForm.elements["txtUP"].value = theForm.elements["txtOriUP"].value*2};

            if (theForm.elements["cmbOriCurrCode"].value == 'NTD')
                {theForm.elements["txtUP"].value = theForm.elements["txtOriUP"].value*3};
        }

}

function ShowUp()
{
    eval('var theForm = ' + document.forms[0].name + ';');
    if (theForm.elements["txtOriUP"].value != null)
            {theForm.elements["txtUP"].value = (theForm.elements["txtOriUP"].value /theForm.elements["txtConRate"].value * theForm.elements["txtHandlingCharges"].value)};
}

function BlankQty(aspTextBoxID){
            re = new RegExp(':' + aspTextBoxID + '$')
            for(i=0;i<document.forms[0].elements.length;i++){
                    elm = document.forms[0].elements[i]
                    if (elm.type == 'textbox')
                        {
                            if(re.test(elm.name))
                                {
                                 elm.text='0'
                                }
                        }
                }
        }
