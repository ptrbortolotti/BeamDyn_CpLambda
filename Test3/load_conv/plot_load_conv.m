clc; close all; clear all;

filename = 'bd_results.txt';
delete(sprintf('%s',filename))
fid = fopen(filename, 'wt');

[~,git_hash_string] = system('git -C /Users/asharma/codes/F_Code/openfast rev-parse HEAD');
fprintf(fid, '# SHA Id: %s\n', git_hash_string);
fprintf(fid,'%s \t %18s \t %20s \t %15s \t %18s \t %18s \t %18s\n','F','u_x(tip)','u_y(tip)','u_z(tip)','r_x(tip)','r_y(tip)','r_z(tip)');

%%
load = 500000;
f = [0.2,0.4,0.6,0.8,1.0,2.0,4.0]*load;

file_out = '/Users/asharma/codes/F_Code/currTests/beamdyn_val_2020/15mw_box/beam_1_static/load_conv/f_1e6/Box_Beam_driver.out';
data_stat_p2 = dlmread(file_out, '', 8, 0);
data_stat_p2 = data_stat_p2(end,2:end);
fprintf(fid,'%d \t %2.16f \t %2.16f \t %2.16f \t %2.16f \t %2.16f \t %2.16f\n',f(1),data_stat_p2');

file_out = '/Users/asharma/codes/F_Code/currTests/beamdyn_val_2020/15mw_box/beam_1_static/load_conv/f_2e6/Box_Beam_driver.out';
data_stat_p4 = dlmread(file_out, '', 8, 0);
data_stat_p4 = data_stat_p4(end,2:end);
fprintf(fid,'%d \t %2.16f \t %2.16f \t %2.16f \t %2.16f \t %2.16f \t %2.16f\n',f(2),data_stat_p4');

file_out = '/Users/asharma/codes/F_Code/currTests/beamdyn_val_2020/15mw_box/beam_1_static/load_conv/f_3e6/Box_Beam_driver.out';
data_stat_p6 = dlmread(file_out, '', 8, 0);
data_stat_p6 = data_stat_p6(end,2:end);
fprintf(fid,'%d \t %2.16f \t %2.16f \t %2.16f \t %2.16f \t %2.16f \t %2.16f\n',f(3),data_stat_p6');

file_out = '/Users/asharma/codes/F_Code/currTests/beamdyn_val_2020/15mw_box/beam_1_static/load_conv/f_4e6/Box_Beam_driver.out';
data_stat_p8 = dlmread(file_out, '', 8, 0);
data_stat_p8 = data_stat_p8(end,2:end);
fprintf(fid,'%d \t %2.16f \t %2.16f \t %2.16f \t %2.16f \t %2.16f \t %2.16f\n',f(4),data_stat_p8');

file_out = '/Users/asharma/codes/F_Code/currTests/beamdyn_val_2020/15mw_box/beam_1_static/load_conv/f_5e6/Box_Beam_driver.out';
data_stat_1 = dlmread(file_out, '', 8, 0);
data_stat_1 = data_stat_1(end,2:end);
fprintf(fid,'%d \t %2.16f \t %2.16f \t %2.16f \t %2.16f \t %2.16f \t %2.16f\n',f(5),data_stat_1');

file_out = '/Users/asharma/codes/F_Code/currTests/beamdyn_val_2020/15mw_box/beam_1_static/load_conv/f_10e6/Box_Beam_driver.out';
data_stat_1p2 = dlmread(file_out, '', 8, 0);
data_stat_1p2 = data_stat_1p2(end,2:end);
fprintf(fid,'%d \t %2.16f \t %2.16f \t %2.16f \t %2.16f \t %2.16f \t %2.16f\n',f(6),data_stat_1p2');

file_out = '/Users/asharma/codes/F_Code/currTests/beamdyn_val_2020/15mw_box/beam_1_static/load_conv/f_20e6/Box_Beam_driver.out';
data_stat_1p4 = dlmread(file_out, '', 8, 0);
data_stat_1p4 = data_stat_1p4(end,2:end);
fprintf(fid,'%d \t %2.16f \t %2.16f \t %2.16f \t %2.16f \t %2.16f \t %2.16f\n',f(7),data_stat_1p4');

fclose(fid);
%%

data_stat = [data_stat_p2;data_stat_p4;data_stat_p6;data_stat_p8;data_stat_1;data_stat_1p2;data_stat_1p4];

figure(1)
clf

subplot(2,3,1)
plot(f,data_stat(:,1),'-*k','LineWidth', 2);
xlabel('f','Interpreter','latex'); ylabel('$u_x$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

subplot(2,3,2)
plot(f,data_stat(:,2),'-*k','LineWidth', 2);
xlabel('f','Interpreter','latex'); ylabel('$u_y$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

subplot(2,3,3)
plot(f,data_stat(:,3),'-*k','LineWidth', 2);
xlabel('f','Interpreter','latex'); ylabel('$u_z$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

subplot(2,3,4)
plot(f,data_stat(:,4),'-*k','LineWidth', 2);
xlabel('p','Interpreter','latex'); ylabel('$r_x$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

subplot(2,3,5)
plot(f,data_stat(:,5),'-*k','LineWidth', 2);
xlabel('f','Interpreter','latex'); ylabel('$r_y$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

subplot(2,3,6)
plot(f,data_stat(:,6),'-*k','LineWidth', 2);
xlabel('f','Interpreter','latex'); ylabel('$r_z$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

