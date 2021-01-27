clc; close all; clear all;

%%
f = [2e5,5e5,1e6,1.5e6,2e6,4e6,5e6,8e6,1e7];

f_string = ["2e5","5e5","1e6","1.5e6","2e6","4e6","5e6","8e6","1e7"];

disp_stat = dlmread('/Users/asharma/codes/F_Code/currTests/beamdyn_val_2020/solid_curved_beam/bd_static_load_conv/bd_results.txt', '', 3, 0);
disp_stat = disp_stat(:,2:end);

disp_stat_new = [];
for i = 1:length(f)
    file_out = strcat('/Users/asharma/codes/F_Code/currTests/beamdyn_val_2020/solid_curved_beam/bd_static_load_conv_new/f_',f_string(i),'/solid_beam_driver.out');
    data = dlmread(file_out, '', 8, 0);
    data = data(end,2:end);    
    disp_stat_new = [disp_stat_new; data];
end

%%

figure(1)
clf

subplot(2,3,1)
plot(f,disp_stat(:,1),'-*k','LineWidth', 2);
hold on
plot(f,disp_stat_new(:,1),'--ob','LineWidth', 2);
xlabel('f','Interpreter','latex'); ylabel('$u_x$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

subplot(2,3,2)
plot(f,disp_stat(:,2),'-*k','LineWidth', 2);
hold on
plot(f,disp_stat_new(:,2),'--ob','LineWidth', 2);
xlabel('f','Interpreter','latex'); ylabel('$u_y$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

subplot(2,3,3)
plot(f,disp_stat(:,3),'-*k','LineWidth', 2);
hold on
plot(f,disp_stat_new(:,3),'--ob','LineWidth', 2);
xlabel('f','Interpreter','latex'); ylabel('$u_z$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

subplot(2,3,4)
plot(f,disp_stat(:,4),'-*k','LineWidth', 2);
hold on
plot(f,disp_stat_new(:,4),'--ob','LineWidth', 2);
xlabel('f','Interpreter','latex'); ylabel('$r_x$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

subplot(2,3,5)
plot(f,disp_stat(:,5),'-*k','LineWidth', 2);
hold on
plot(f,disp_stat_new(:,5),'--ob','LineWidth', 2);
xlabel('f','Interpreter','latex'); ylabel('$r_y$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

subplot(2,3,6)
plot(f,disp_stat(:,6),'-*k','LineWidth', 2);
hold on
plot(f,disp_stat_new(:,6),'--ob','LineWidth', 2);
xlabel('f','Interpreter','latex'); ylabel('$r_z$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

