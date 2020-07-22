%% animation
function anima_pred_zb(YY_avg,zb_hat,zb_hat_filtered,zb_mf,lower1,upper1,lower2,upper2,window,l)
% set paramater
figure;
start_run = window*12+1; 
end_run =length(zb_hat);
n = size(YY_avg,1);
ns    =   num2str(n);
txts  =   ['总样本数：',ns];
ts    =   (2:28);
FS = 10;

for i  = start_run:end_run
  
    subplot(1,2,1);
    bar(ts, YY_avg(i,ts-1), .75); axis([0,29,-20,520]);
    colormap(summer);
    
    text(1,350,txts,'fontsize',FS); % 总样本数；
    
    is    =   num2str(i);
    txti  =   ['样本序数：',is];  text(1,500,txti,'fontsize',FS);
    
    title('第 2 -- 28 号风箱废气 温度','fontsize',FS);
    grid minor;
    hold on;
    
    plot([1,1,10,10,1],[400,410,410,400,400],'b');
    sn  =  i/n * 8.6 + 1.2;
    plot([1.2,sn],[405,405],'r','LineWidth',5);
    plot([0,29],[100,100],'r');
    
    hold off;
%----------------------------------------------------------------------------
%----------------------------------------------------------------------------
%----------------------------------------------------------------------------
%----------------------------------------------------------------------------

    subplot(1,2,2);
    %---------------------------------------------------------------
    z_window  =  i-window*12:i;
    %--------------------------------------------------------------
    plot(z_window,zb_hat(z_window),'.-m','MarkerSize',10,'LineWidth',2);
    title('BTP 实时在线估计(每分钟)','fontsize',10);
    hold on;
    plot(i,zb_hat(i),'ok','MarkerSize',10);
    plot(z_window,zb_hat_filtered(z_window),'-.g','MarkerSize',10,'LineWidth',2);
     % forecast
    
     z_window_f=i-window*12:i+l*12-1;

     
     plot(z_window_f,zb_mf(z_window_f),'.-','MarkerSize',5,'LineWidth',2);hold on;
     plot(i+l*12-1,zb_mf(i+l*12-1),'dr','MarkerSize',10);
     yForFill1=[upper1(z_window_f)',fliplr(lower1(z_window_f)')];
     xForFill1=[z_window_f,fliplr(z_window_f)];
     fill(xForFill1,yForFill1,'c','FaceAlpha',0.2,'EdgeAlpha',1,'EdgeColor','c'); % 填充并设置图形格式
     
     yForFill2=[upper2(z_window_f)',fliplr(lower2(z_window_f)')];
     xForFill2=[z_window_f,fliplr(z_window_f)];
     fill(xForFill2,yForFill2,'r','FaceAlpha',0.2,'EdgeAlpha',1,'EdgeColor','r'); % 填充并设置图形格式
     
    xlim([i-window*12, i+l*12+1]);
    ylim([66, 73]);
    line([i-window*12,i+1+l*12],[67,67],'LineWidth',3,'Color','r');
    line([i-window*12,i+1+l*12],[70,70],'LineWidth',3,'Color',[178,34,34]./256);
    line([i-window*12,i+1+l*12],[72,72],'LineWidth',3,'Color','r');
    line([(window+l)*12,(window+l)*12],[64,74],'LineWidth',2,'Color',[41,51,61]./256);
    grid on; grid minor;
    hold off
    drawnow;
    
    %pause(0.3)   
end
figure;
plot(zb_hat,'.-');ylim([min(zb_hat)-2 max(zb_hat)+2]);
hold on
plot(zb_mf,'.-');
plot(zb_hat_filtered,'.-g');
plot(lower1,'k--','LineWidth',2);
plot(upper1,'k--','LineWidth',2);
plot(lower2,'k:','LineWidth',2);
plot(upper2,'k:','LineWidth',2);
legend('origin','predict');
hold off

end