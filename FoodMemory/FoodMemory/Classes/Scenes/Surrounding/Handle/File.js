//设置当前版本目录
var public_dir = 'app_1_4';

window.onerror = function(err) {
    log('window.onerror: ' + err)
}

function connectWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) {
        callback(WebViewJavascriptBridge)
    } else {
        document.addEventListener('WebViewJavascriptBridgeReady', function() {
                                  callback(WebViewJavascriptBridge)
                                  }, false)
    }
}

connectWebViewJavascriptBridge(function(bridge) {
                               var uniqueId = 1
                               function log(message, data) {
                               var log = document.getElementById('log')
                               var el = document.createElement('div')
                               el.className = 'logLine'
                               el.innerHTML = uniqueId++ + '. ' + message + ':<br/>' + JSON.stringify(data)
                               if (log.children.length) { log.insertBefore(el, log.children[0]) }
                               else { log.appendChild(el) }
                               }
                               bridge.init(function(message, responseCallback) {
                                           log('JS got a message', message)
                                           var data = { 'Javascript Responds':'Wee!' }
                                           log('JS responding with', data)
                                           responseCallback(data)
                                           })
                               })

//打开页面  title 标题 ； url 打开url地址 ；    type 打开页面的类型 1 美食详情  2 攻略详情  3 购买页面
function OpenUrl(title,url,type){
    window.WebViewJavascriptBridge.callHandler('openURLFunc', {'title': title, 'url': url, 'type': type}, function(response) {})
}

//分享        参数说明:title 分享标题;    url 分享url地址;   content 分享内容;   imagePath   分享图片地址
function ShareUrl(title,url,content,imagePath,sharetype,id){
    //alert('ShareUrl');
    window.WebViewJavascriptBridge.callHandler('shareFunc', {'title': title, 'url': url, 'content': content, 'imagePath': imagePath, 'sharetype': sharetype, 'id': id}, function(response) {});
}

//购买商品接口        参数说明:ptid 商品平台ID;    url 商品url地址;
function openAppUrlFunc(ptid,url,tracking_id){
    window.WebViewJavascriptBridge.callHandler('openAppUrlFunc', {'ptid': ptid, 'url': url, 'tracking_id': tracking_id}, function(response) {});
}

//判断登录  是登录状态, 返回uId, nickName, profileImage  否则返回空
function isLogin(){
    window.WebViewJavascriptBridge.callHandler('isLoginedFunc', {}, function(response) {
                                               
                                               });
}

//调用登录
function Login(){
    window.WebViewJavascriptBridge.callHandler('loginFunc', {}, function(response) {
                                               
                                               });
}

//意见反馈
function feedback(){
    window.WebViewJavascriptBridge.callHandler('feedbackFunc', {}, function(response) {
                                               
                                               });
}

//评论调用，判断是否登录，如果登录则直接评论，否则提示登录
function submit_pl(pl_id,re_userid,raiders_id,pid){
    window.WebViewJavascriptBridge.callHandler('isLoginedFunc', {}, function(response) {
                                               if(response==undefined || response=="" || response==null){
                                               Login();
                                               }else{
                                               submit_ajax(pl_id,re_userid,raiders_id,pid,response.uId);
                                               }
                                               });
}

//评论发送，返还数据页面输出，并且关闭评论的小框
function submit_ajax(pl_id,re_userid,raiders_id,pid,userid){
    var comment_value = $("#"+pl_id+" .pl_fabu .input_pl_fabu").val();
    if(comment_value == undefined){
        comment_value = $("#"+pl_id+" .content_pltc .content_nei .pltc_textarea").val();
    }
    if(comment_value == undefined || comment_value == '请输入评论内容' || comment_value == '请输入回复内容' ){
        alert('请输入评论内容');
    }else{
        $.ajax({
               type: "POST",
               url: "/"+public_dir+"/api/comment",
               data: "userid="+userid+"&re_userid="+re_userid+"&comment="+comment_value+"&raiders_id="+raiders_id+"&pid="+pid,
               success: function(msg){
               $(".pl_tit").after(msg);
               $("#"+pl_id).css("display","none");
               $(".content_mark").css("display","none");
               $("#box_pl").css("display","none");
               $(".shiluang").text(Number($(".shiluang").text())+1);
               $(".pl_tit").text("评论("+Number($(".shiluang").text())+")");
               }
               });
        //插入返还内容,并且在评论最上面插入，关闭评论框；
        $(".pl_tit").after(msg);
    }
}

//评论调用，判断是否登录，如果登录则直接评论，否则提示登录
function submit_pl_new(){
    window.WebViewJavascriptBridge.callHandler('isLoginedFunc', {}, function(response) {
                                               if(response==undefined || response=="" || response==null){
                                               Login();
                                               }else{
                                               submit_ajax_new(response.uId);
                                               }
                                               });
}

//评论发送，返还数据页面输出，并且关闭评论的小框
//回复的用户ID re_userid,  文章ID raiders_id, 父级ID pid, 评论ID userid
function submit_ajax_new(userid){
    
    var pid = $("#comment_id").val();
    var re_userid = $("#re_userid").val();
    var raiders_id = $("#raiders_id").val();
    
    var comment_value = $(".zzsc_0 .content_0 .pltc_textarea").val();
    if(comment_value == undefined || comment_value == '请输入评论内容' || comment_value == '请输入回复内容' || comment_value == '' ){
        $("#pinglun_nei").focus();
        $("textarea[name=demo]").attr({ placeholder: '请输入评论内容……'});
        $('.imgs_0').show(0);
        $('.content_mark_0').show(0);
    }else{
        $.ajax({
               type: "POST",
               url: "/"+public_dir+"/api/comment",
               data: "userid="+userid+"&re_userid="+re_userid+"&comment="+comment_value+"&raiders_id="+raiders_id+"&pid="+pid,
               success: function(msg){
               $(".pl_tit").after(msg);
               $(".shiluang").text(Number($(".shiluang").text())+1);
               $(".pl_tit").text("评论("+Number($(".shiluang").text())+")");
               
               $('.zzsc_0').hide(0);
               $('.content_mark_0').hide(0);
               $("#comment_id").val('');
               $("#re_userid").val('');
               $("#raiders_id").val('');
               $(".zzsc_0 .content_0 .pltc_textarea").val('');
               }
               });
        //插入返还内容,并且在评论最上面插入，关闭评论框；
        $(".pl_tit").after(msg);
    }
}

//攻略内页 五角星收藏
function Mylike(id){
    window.WebViewJavascriptBridge.callHandler('isLoginedFunc', {}, function(response) {
                                               if(response==undefined || response=="" || response==null){
                                               Login();
                                               }else{
                                               var ids = '';
                                               ids = id.split("_");
                                               var state = $("#"+id).find('img').attr("like");
                                               if(state == '1'){
                                               $("#"+id).find('span').eq(0).text(Number($("#"+id).find('span').eq(0).text())-1);
                                               $("#"+id).find('img').eq(0).attr({ src: "/public/"+public_dir+"/images/sc.png", alt: "收藏" ,like: "0" });
                                               }else{
                                               $("#"+id).find('span').eq(0).text(Number($("#"+id).find('span').eq(0).text())+1);
                                               $("#"+id).find('img').eq(0).attr({ src: "/public/"+public_dir+"/images/sc_d.png", alt: "取消收藏" ,like: "1" });
                                               }
                                               
                                               Mylike_get(ids[1],state,ids[0],response.uId);
                                               }
                                               });
}

//列表页爱心 型收藏
function Mylike_love(id){
    window.WebViewJavascriptBridge.callHandler('isLoginedFunc', {}, function(response) {
                                               if(response==undefined || response=="" || response==null){
                                               Login();
                                               }else{
                                               var ids = id.split("_");
                                               var state = $("#"+id).find('img').attr("like");
                                               if(state == '1'){
                                               $("#"+id).find('span').text(Number($("#"+id).find('span').text())-1);
                                               $("#"+id).find('img').eq(0).attr({ src: "/public/"+public_dir+"/images/sc02.png", alt: "收藏" ,like: "0" });
                                               }else{
                                               $("#"+id).find('span').text(Number($("#"+id).find('span').text())+1);
                                               $("#"+id).find('img').eq(0).attr({ src: "/public/"+public_dir+"/images/sc02_d.png", alt: "取消收藏" ,like: "1" });
                                               }
                                               Mylike_get(ids[1],state,ids[0],response.uId);
                                               }
                                               });
}


//商品/攻略内页收藏商品
function Mylike_nei(id){
    window.WebViewJavascriptBridge.callHandler('isLoginedFunc', {}, function(response) {
                                               if(response==undefined || response=="" || response==null){
                                               Login();
                                               }else{
                                               var ids = '';
                                               ids = id.split("_");
                                               var state = $("#"+id).find('img').attr("like");
                                               if(state == '1'){
                                               $("#"+id).html('<img src="/public/'+public_dir+'/images/sc02.png" alt="收藏" like="0"/><span>收藏</span>');
                                               }else{
                                               $("#"+id).html('<img src="/public/'+public_dir+'/images/sc02_d.png" alt="已收藏" like="1"/><span style="color:#d73852;">已收藏</span>');
                                               }
                                               Mylike_get(ids[1],state,ids[0],response.uId);
                                               }
                                               });
}

//商品/攻略内页收藏商品
function Mylike_food(id){
    window.WebViewJavascriptBridge.callHandler('isLoginedFunc', {}, function(response) {
                                               if(response==undefined || response=="" || response==null){
                                               Login();
                                               }else{
                                               var ids = '';
                                               ids = id.split("_");
                                               var state = $("#"+id).find('img').attr("like");
                                               if(state == '1'){
                                               $("#"+id).html('<img src="/public/'+public_dir+'/images/sc.png" alt="收藏" like="0"/><span>收藏</span>');
                                               }else{
                                               $("#"+id).html('<img src="/public/'+public_dir+'/images/sc_d.png" alt="已收藏" like="1"/><span style="color:#d73852;">已收藏</span>');
                                               }
                                               Mylike_get(ids[1],state,ids[0],response.uId);
                                               }
                                               });
}

//收藏商品，发送请求给保存数据，无回调；
function Mylike_get(sid,state,type,uid){
    //$.get("/app/like/mylike/"+sid+"?t="+Math.random());
    //$.get("/app/like/mylike?t="+Math.random(),{sid : sid, del : state, type : type, uid : uid, fd : '1'});
    $.get("/"+public_dir+"/like/mylike?t="+Math.random(),{sid : sid, del : state, type : type, uid : uid, fd : '2'},
          function(data){
          //alert("get Data Loaded: " + data);
          }
          );
    /*$.ajax({
     type: "GET",
     url: "../like/mylike?t="+Math.random(),
     data: "sid="+sid+"&del="+state+"&type="+type+"&uid="+uid+"&f=3",
     success: function(msg){
     alert( "ajax Data Saved: " + msg );
     }
     });*/
}



//调用刷新
var ajaxdata_return = 1;

function loadPage(uid,utype){
    var lastid = $("#lastid").val();
    if(ajaxdata_return == 1){
        ajaxdata_return = -1;
        $.ajax({
               type: "GET",
               url: "/"+public_dir+"/hot/load_"+utype,
               data: 'uid='+uid+"&lastid="+lastid+"&t="+Math.random(),
               dataType: "json",
               success: function(data){
               if (data.html != '') { 
               $("#content").prepend(data.html);
               if(data.utype == 'food'){
	            		$("#lastid").val(data.endtime);
               }else{
	            		$("#lastid").val(data.endtime);
               }
               }
               ajaxdata_return = 1;
               window.WebViewJavascriptBridge.callHandler('loadPageOK', {}, function(response) {});
               },
               error: function(data,e){
               ajaxdata_return = 1;
               }
               });
    }
}


//分享回调，类型，文章ID
function ShareCount(sharetype,kid){ 
    $.get("/"+public_dir+"/api/share_"+sharetype,{ id: kid , t: Math.random()} );
    var main = $("#share_"+sharetype+"_"+kid);
    main.find('span').text(Number(main.find('span').text())+1);
}



//攻略内页 五角星收藏     收藏页面删除
function like_Mylike(id){
    window.WebViewJavascriptBridge.callHandler('isLoginedFunc', {}, function(response) {
                                               if(response==undefined || response=="" || response==null){  
                                               Login();
                                               }else{
                                               var ids = '';
                                               ids = id.split("_");
                                               var state = $("#"+id).find('img').attr("like");
                                               if(state == '1'){
                                               $("#"+id).find('span').eq(0).text(Number($("#"+id).find('span').eq(0).text())-1);
                                               $("#"+id).find('img').eq(0).attr({ src: "/public/"+public_dir+"/images/sc.png", alt: "收藏" ,like: "0" });
                                               }else{
                                               $("#"+id).find('span').eq(0).text(Number($("#"+id).find('span').eq(0).text())+1);
                                               $("#"+id).find('img').eq(0).attr({ src: "/public/"+public_dir+"/images/sc_d.png", alt: "取消收藏" ,like: "1" });
                                               }
                                               
                                               $("#"+id).parent().parent().remove();
                                               Mylike_get(ids[1],state,ids[0],response.uId);
                                               }
                                               });
}

//列表页爱心 型收藏   收藏页面删除
function like_Mylike_love(id){
    window.WebViewJavascriptBridge.callHandler('isLoginedFunc', {}, function(response) {
                                               if(response==undefined || response=="" || response==null){  
                                               Login();
                                               }else{
                                               var ids = id.split("_");
                                               var state = $("#"+id).find('img').attr("like");
                                               if(state == '1'){
                                               $("#"+id).find('span').text(Number($("#"+id).find('span').text())-1);
                                               $("#"+id).find('img').eq(0).attr({ src: "/public/"+public_dir+"/images/sc02.png", alt: "收藏" ,like: "0" });
                                               }else{
                                               $("#"+id).find('span').text(Number($("#"+id).find('span').text())+1);
                                               $("#"+id).find('img').eq(0).attr({ src: "/public/"+public_dir+"/images/sc02_d.png", alt: "取消收藏" ,like: "1" });
                                               }
                                               $("#"+id).parent().parent().parent().remove();
                                               Mylike_get(ids[1],state,ids[0],response.uId);
                                               }
                                               });
}


//获取上次刷新时间，获取指定时间后更新的数量
function up_time_food(){
    var endtime = $("#lastid").val();
    return endtime;
}



/*********************APP_1_4添加*******************************/
//调用刷新
var ajax_appload_20151105 = 1;
//uid,utype,yemian  用户UID,页面类型 food raiders，页面：首页（shouye），发现（faxian），分类（fenlei）
function appload_20151105(uid,utype,yemian){
    var typeid = $("#typeid").val();
    var gift_id_down = $("#gift_id_down").val();
    if(ajax_appload_20151105 == 1){
        ajax_appload_20151105 = -1;
        $.ajax({
               type: "GET",
               url:  "/"+public_dir+"/day/load",
               data: "uid="+uid+"&typeid="+typeid+"&gift_id_down="+gift_id_down+"&t="+Math.random(),
               dataType: "json",
               success: function(data){
               if (data.html != 'null') { 
               $("#content").prepend(data.html);
               $("#gift_id_down").val(data.gift_id_down);
               }
               ajax_appload_20151105 = 1;
               window.WebViewJavascriptBridge.callHandler('loadPageOK', {}, function(response) {});
               },
               error: function(data,e){
               ajax_appload_20151105 = 1;
               }
               });
    }
}

