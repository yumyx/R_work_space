

function submit() {

    document.getElementById("input").style.display="none";

    var re= new Array();
    var obj=new Object();
    for(var i=0;i< gqus.length;++i)
    {

        var qu=gqus[i];
        var objstr;
        if(qu.val==null)
            objstr="obj."+qu.name+"=null;";
        else
            objstr="obj."+qu.name+"= "+qu.val+";";
        //objstr="obj."+qu.name+"= '"+qu.val+"';";

        eval(objstr);


        //re[qu.id-1]=obj;
    }
    re[0]=obj;
    var jre=JSON.stringify(re);
    //alert(jre);

    Shiny.setInputValue("submit",jre);


}


    function initList(json) {

        var len=json.length;

        var out="";

        var ki=0;
        var qu=null;
        var qus= new Array();
        var qi=0;
        var li=0

        for(var i=0;i<len;++i) {
            var row = json[i];


            var j=0

            out+="["+qi+"."+ki+"]";

            for (name in row) {

                if(ki==0)
                {
                    qu=new Object();

                    qu.id= parseInt( name.substring(1));
                    qu.name=row[name];
                    qu.list=new Array();
                }
                else if(ki==1)
                {
                    qu.txt=row[name];
                    li=0;
                    qu.list= new Array();
                }
                else
                {
                    //qu.list[li]={};
                    if(name=="X1") {
                        qu.list[li]=new Object();
                        qu.list[li].txt=row[name];

                    }
                    else if(name=="X2")
                    {
                        qu.list[li].val=row[name];
                        ++li;

                    }


                }

                out+=" name: " + name + ", value: " + row[name];
                ++j;

            }
            ++ki;
            if(j==0 ||(i>=(len-1)))
            {
                qus[qi]=qu;
                ++qi;
                ki=0;
                li=0;
                out+="================"
            }
            out+="\n"
        }

        // alert(out);
        return qus;



    }


function myFunction()
{
    //$("#n").val("300")
    //  $("#h01").html("Hello jQuery")

    //  var o=document.getElementById("n");
    //    o.focus();
    //  o.value="300";//自动赋值以后文本框已经change，理论上要发生onchange事件
    //但是如果不加以下这句是不会触发onchange事件的
    //o.fireEvent("onchange");

    //    Shiny.setInputValue("n", "200")
    // Shiny.setInputValue("submit","submit");
    //     alert("Shiny.setInputValue");

}
//$(document).ready(myFunction);
var gqus;
var gpos;
var gqu;

var quhtml=document.getElementById("question");


function radioClk(pthis) {

    gqu.val=pthis.value;

}

function showquestNext(dir)
{
    var pos=gpos+dir;
    showquest(gqus,pos);

}

function showquest(qus,pos) {
    gqus=qus;

    if(pos>=qus.length || pos<0)
        return null;

    gqu=qus[pos];

    var i=0;

//<input type="radio" name="sex" value="male">Male
    var out=""

    //out+="<p><b>"+gqu.txt+"</b></p>";
    out+='<label class="control-label" ><b>['+(pos+1)+"/"+gqus.length+"]&nbsp;"+gqu.txt+'</b></label>'
    out+='<div class="shiny-options-group">';
    for(var i=0;i<gqu.list.length;++i) {
        var list = gqu.list[i];
        var ck="";
        if(gqu.val==list.val)
            ck="checked";
        /*
        <div class="shiny-options-group">
  <div class="radio"> <label><input type="radio" name="extra1" value="1" checked="checked"><span>Never..1</span></label></div>
         */

        // out += "<input  onclick='radioClk(this)' type='radio' name='sel' value='" + list.val + "'"+ck+">" + list.txt + "<br>\n";
        out+=' <div class="radio"> <label><input  onclick="radioClk(this)" type="radio" name="extra1" value="'+ list.val + '"'+ck+'><span>'+list.txt+'</span></label></div>';
    }
    out+="</div>";


    quhtml.innerHTML=out;


    gpos=pos;

}

Shiny.addCustomMessageHandler('json', function(json) {
    //alert("recieve from R color"+json);
    var qus=initList(json);
    showquest(qus,0);

    // document.body.style.backgroundColor = color;
    // document.body.innerText = color;
});


