clc; close all; clear all;

filename = 'bd_results.txt';
delete(sprintf('%s',filename))
fid = fopen(filename, 'wt');

[~,git_hash_string] = system('git -C /Users/asharma/codes/F_Code/openfast rev-parse HEAD');
fprintf(fid, '# SHA Id: %s\n', git_hash_string);
fprintf(fid,'%s \t %18s \t %20s \t %15s \t %18s \t %18s \t %18s\n','F','u_x(tip)','u_y(tip)','u_z(tip)','r_x(tip)','r_y(tip)','r_z(tip)');

%%
f = [1e4,2e4,4e4,6e4,8e4, ...
    1e5,2e5,4e5,6e5,8e5, ...
    1e6,1.5e6,2e6,2.5e6,3e6,4e6,6e6,8e6, ...
    1e7];

f_string = ["1e4","2e4","4e4","6e4","8e4", ...
    "1e5","2e5","4e5","6e5","8e5", ...
    "1e6","1.5e6","2e6","2.5e6","3e6","4e6","6e6","8e6", ...
    "1e7"];

disp_stat = [];
for i = 1:length(f)
    file_out = strcat('/Users/asharma/codes/F_Code/currTests/beamdyn_val_2020/solid_beam/bd_static_load_conv/f_',f_string(i),'/solid_beam_driver.out');
    data = dlmread(file_out, '', 8, 0);
    data = data(end,2:end);
    fprintf(fid,'%d \t %2.16e \t %2.16e \t %2.16e \t %2.16e \t %2.16e \t %2.16e\n',f(i),data');
    
    disp_stat = [disp_stat; data];
end

fclose(fid);
%%

figure(1)
clf

subplot(2,3,1)
plot(f,disp_stat(:,1),'-*k','LineWidth', 2);
xlabel('f','Interpreter','latex'); ylabel('$u_x$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

subplot(2,3,2)
plot(f,disp_stat(:,2),'-*k','LineWidth', 2);
xlabel('f','Interpreter','latex'); ylabel('$u_y$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

subplot(2,3,3)
plot(f,disp_stat(:,3),'-*k','LineWidth', 2);
xlabel('f','Interpreter','latex'); ylabel('$u_z$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

subplot(2,3,4)
plot(f,disp_stat(:,4),'-*k','LineWidth', 2);
xlabel('p','Interpreter','latex'); ylabel('$r_x$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

subplot(2,3,5)
plot(f,disp_stat(:,5),'-*k','LineWidth', 2);
xlabel('f','Interpreter','latex'); ylabel('$r_y$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

subplot(2,3,6)
plot(f,disp_stat(:,6),'-*k','LineWidth', 2);
xlabel('f','Interpreter','latex'); ylabel('$r_z$','Interpreter','latex');
set(gcf,'color','w');
set(gca, 'FontSize', 18);
set(gca,'TickLabelInterpreter','latex');

