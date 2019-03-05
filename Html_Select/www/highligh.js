var show_hight_last=Array();

function _show_hight(i,pthis)
{
    if(show_hight_last[i]!=null) {
       // show_hight_last.className="hadRead";
        show_hight_last[i].style.backgroundColor="";


    }
    //pthis.className="high_light";
    pthis.style.backgroundColor="#EDBB99";
    show_hight_last[i]=pthis;
}



var HightLightn=0;

function HightLight() {
    this.no = ++HightLightn;
    this.m_highliht = null;


    this.show = (pthis) => {

        if (this.m_highliht != null)
            this.m_highliht.style.backgroundColor = "";
        pthis.style.backgroundColor = "#EDBB99";
        this.m_highliht = pthis;
    };
}

var ghightLight=new HightLight();


function show_hight(pthis)
{
    //_show_hight(0,pthis);
    ghightLight.show(pthis);

}

