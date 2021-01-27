clc; close all; clear all;

filename = 'bd_results.txt';
delete(sprintf('%s',filename))
fid = fopen(filename, 'wt');

[~,git_hash_string] = system('git -C /Users/asharma/codes/F_Code/openfast rev-parse HEAD');
fprintf(fid, '# SHA Id: %s\n', git_hash_string);
fprintf(fid,'%s \t %18s \t %20s \t %15s \t %18s \t %18s \t %18s\n','F','u_x(tip)','u_y(tip)','u_z(tip)','r_x(tip)','r_y(tip)','r_z(tip)');

%%
load = 5000;
f = [1e3,2e3,3e3,4e3,5e3];

file_out = '/Users/asharma/codes/F_Code/currTests/beamdyn_val_2020/15mw_box/beam_2_static/load_conv/f_1e3/Box_Beam_driver.out';
data_stat_1e3 = dlmread(file_out, '', 8, 0);
data_stat_1e3 = data_stat_1e3(end,2:end);
fprintf(fid,'%d \t %2.16e \t %2.16e \t %2.16e \t %2.16e \t %2.16e \t %2.16e\n',f(1),data_stat_1e3');

file_out = '/Users/asharma/codes/F_Code/currTests/beamdyn_val_2020/15mw_box/beam_2_static/load_conv/f_2e3/Box_Beam_driver.out';
data_stat_2e3 = dlmread(file_out, '', 8, 0);
data_stat_2e3 = data_stat_2e3(end,2:end);
fprintf(fid,'%d \t %2.16e \t %2.16e \t %2.16e \t %2.16e \t %2.16e \t %2.16e\n',f(2),data_stat_2e3');

file_out = '/Users/asharma/codes/F_Code/currTests/beamdyn_val_2020/15mw_box/beam_2_static/load_conv/f_3e3/Box_Beam_driver.out';
data_stat_3e3 = dlmread(file_out, '', 8, 0);
data_stat_3e3 = data_stat_3e3(end,2:end);
fprintf(fid,'%d \t %2.16e \t %2.16e \t %2.16e \t %2.16e \t %2.16e \t %2.16e\n',f(3),data_stat_3e3');

file_out = '/Users/asharma/codes/F_Code/currTests/beamdyn_val_2020/15mw_box/beam_2_static/load_conv/f_4e3/Box_Beam_driver.out';
data_stat_4e3 = dlmread(file_out, '', 8, 0);
data_stat_4e3 = data_stat_4e3(end,2:end);
fprintf(fid,'%d \t %2.16e \t %2.16e \t %2.16e \t %2.16e \t %2.16e \t %2.16e\n',f(4),data_stat_4e3');

file_out = '/Users/asharma/codes/F_Code/currTests/beamdyn_val_2020/15mw_box/beam_2_static/load_conv/f_5e3/Box_Beam_driver.out';
data_stat_5e3 = dlmread(file_out, '', 8, 0);
data_stat_5e3 = data_stat_5e3(end,2:end);
fprintf(fid,'%d \t %2.16e \t %2.16e \t %2.16e \t %2.16e \t %2.16e \t %2.16e\n',f(5),data_stat_5e3');

fclose(fid);
%%

data_stat = [data_stat_1e3;data_stat_2e3;data_stat_3e3;data_stat_4e3;data_stat_5e3];

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

