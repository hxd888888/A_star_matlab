%% 完成日期：2022年1月30日  作者：晨少  花费时间：3 days
%% 单次路径规划
clear all;

%% 初始化智能体
fig = figure();				% 创建图形窗口
hold on;

% 设置区域边界
Estart_x = 0;  Estart_y = 0;
Weight = 80;  High = 80;
dL = 1;   %设置网格大小

axis([Estart_x-5 Weight 0 High]);
axis equal;  %设置屏幕高宽比，使得每个坐标轴的具有均匀的刻度间隔
%添加模糊刻度
set(gca,'XMinorTick','on')
set(gca,'YMinorTick','on')
xlabel('X(m)');    ylabel('Y(m)'); 
grid minor   %在刻度线之间添加次网格线
rectangle('position',[Estart_x,Estart_y,Weight,High],'LineWidth',2);   %画边界

%% 区域网格化
xL = 0:dL:Weight;
yL = 0:dL:High;
[XL , YL] = meshgrid(xL,yL);   %获得网格化后的X矩阵和Y矩阵
C = zeros(size(XL));    %存储网格的高度值
%--------------------%
C(1,:) = 100;   C(:,1) = 100;
C(end,:) = 100; C(:,end) = 100;

%% 设置障碍物覆盖值
%--------------------%
a1(1:21) = 20;
C((20:40),20)=80;
plot((20:40),a1,'k-','LineWidth',2);
%--------------------%
a2(1:30) = 30;
C((1:29),30)=80;
plot((0:29),a2,'k-','LineWidth',2);
%--------------------%
a3(1:20) = 50;
C(50,(31:50))=80;
plot(a3,(31:50),'k-','LineWidth',2);
%--------------------%
a4(1:21) = 60;
C((40:60),60)=80;
plot((40:60),a4,'k-','LineWidth',2);
%--------------------%
a5(1:21) = 25;
C(25,(40:60))=80;
plot(a5,(40:60),'k-','LineWidth',2);
%--------------------%

% 左开口矩形障碍物
% y1(1:16) = 45;
% C((30:45),45)=80;
% plot((30:45),y1,'k-','LineWidth',2);
% 
% y2(1:16) = 30;
% C((30:45),30)=80;
% plot((30:45),y2,'k-','LineWidth',2);
% 
% x3(1:16) = 45;
% C(45,(30:45))=80;
% plot(x3,(30:45),'k-','LineWidth',2);

% set(fig, 'position', get(0,'ScreenSize'));   %全屏显示

drawnow;
set(gca, 'ButtonDownFcn', @clickback);   %设置鼠标左键点击回调函数

global startx;
global starty;
global endx;
global endy;
global click_flag;
click_flag = 0;   %鼠标点击次数
%aaa = imread('./aaa.bmp');
% 等待设置起点和终点
while 1 
    if click_flag == 2 
        break;
    end
    pause(0.01);
end

tic;
%% 调用A星算法获得最短路程和路径
% 最后一个参数：0表示直接显示最短路径  1表示显示最短路径寻找过程  2标志最短路径寻找详细过程（包含尝试过的点）
[dis,road] = Axing_fun(startx,starty,endx,endy,Estart_x,Estart_y,Weight,High,C,0);

tim = strcat('用时：',num2str(toc),'秒');
dis = strcat('已找到最短路径，总路程为：',num2str(dis));
msgbox({dis,tim},'提示','help');
disp([dis,' ',tim]);  

%% 鼠标点击事件
function clickback(hObject, event)
    global startx;
    global starty;
    global endx;
    global endy;
    global click_flag;
    loc = get(gca, 'CurrentPoint');
    xx = round(loc(1,1));
    yy = round(loc(1,2));
    if click_flag == 0
        sta = strcat('起点: ',num2str(xx),' , ',num2str(yy));
        text(xx-4,yy-1.5,sta);
        plot(xx,yy,'r*');
        startx = xx;  starty = yy;
        click_flag = 1;
    elseif click_flag == 1
        sta = strcat('终点: ',num2str(xx),' , ',num2str(yy));
        text(xx-4,yy-1.5,sta);
        plot(xx,yy,'r*');
        endx = xx ;  endy = yy;
        click_flag = 2;
    end
end
