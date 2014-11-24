function digclock()
{
    var d = new Date();
    var t = d.toLocaleTimeString();
    
    document.getElementById("clock").innerHTML = t;
}

setInterval(function(){digclock()},1000);