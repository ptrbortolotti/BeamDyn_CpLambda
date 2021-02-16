function [srf] = MakeNURBS(X,Y,Z)
%
%
%Create surface using X, Y and Z coordinate, applying NURBS theory

for kk = 1:size(X,2) %along blade axis
    s=[];
    u_bar(1,kk)=0;
    u_bar(size(X,1),kk)=1;
    x2 = X(:,kk);
    y2 = Y(:,kk);
    Ds  =  sqrt((x2(2:end)-x2(1:end-1)).^2+(y2(2:end)-y2(1:end-1)).^2);
    s(1) = 0;
    
    send = sum(Ds);
    
    for i=1:length(Ds)
        s(i+1) = s(i)+Ds(i) ;
    end
    
    for jj=2:size(X,1)-1 %at each station
        %Collocation points
        u_bar(jj,kk)= u_bar(jj-1,kk)+ sqrt((x2(jj)-x2(jj-1))^2+(y2(jj)-y2(jj-1))^2)/s(end);
        
    end
end



for jj = 1:size(u_bar,1)
    %Mean of collocation points along blade axis
    u_bar_m(jj) = sum(u_bar(jj,:))/size(X,2);
end

%Chord-wise interpolation

for j = 1:size(X,2) %along blade axis
    
    x2 = X(:,j);
    y2 = Y(:,j);
    
    s=[];
    Ds  =  sqrt((x2(2:end)-x2(1:end-1)).^2+(y2(2:end)-y2(1:end-1)).^2);
    s(1) = 0;
    
    send = sum(Ds);
    
    for i=1:length(Ds)
        s(i+1) = s(i)+Ds(i) ;
    end
    
    %Nodes vector
    u = [];
    u(1:3)=zeros(1,3);
    
    for jj = 1:length(x2)-3-1
        %Internal nodes calculation for a 3� order NURBS
        u(jj+3)= 1/3*sum(u_bar_m((jj+1):(jj+3)));
        
    end
    
    %     u = [0,0,0,0,u, 1 1 1 1]; %FG
    u = [0,u, 1 1 1 1];
    
    %B-spline collocation matrix of order k=p+1=4
    try
        colmat = spcol(u,4,u_bar_m);
    catch
        keyboard
    end
    
    
    %Obtain points of control net, solving linear system.
    x_cn(:,j) = (colmat\x2)';
    y_cn(:,j) = (colmat\y2)';
    z_cn(:,j) = Z(1,j)*ones(size(x_cn,1),1);
end



for j = 1:size(X,2)
    pnts(:,:,j)= [ x_cn(:,j)';y_cn(:,j)' ;z_cn(:,j)'];
    
end

knots{1} = u; % knots along u
knots{2} = [0 0 0  linspace(0,1,size(X,2)-2) 1 1 1]; % knots along v

%Construct the NURBS structure given the control points and the knots

srf = nrbmak(pnts,knots{1});
