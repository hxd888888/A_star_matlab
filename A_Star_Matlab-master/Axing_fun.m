%% A星算法函数
% show_flag: 显示过程标志位,0:直接显示  1:显示搜索过程(不包括边界)  2:显示搜索过程(包括边界)
function [dis,road] = Axing_fun(startx,starty,endx,endy,Estart_x,Estart_y,Weight,High,C,show_flag)
    %-----已探索边界列表-----%
    f = 0 + abs(startx-endx)+abs(starty-endy);  %开始的当前代价为0
    already_frontier = {f,startx,starty,0,[startx,starty]};

    %-----待探索边界列表-----%
    % (第一行是总代价，第二行是横坐标，第三行是纵坐标，第四行是当前代价，第五行是路径)
    frontier = cell(0,5);
    % 寻找邻居点
    N = find_frontier(startx,starty,Estart_x,Estart_x+Weight,Estart_y,Estart_y+High,C,already_frontier);
    % 循环当前边界邻居
    for i = 1:size(N,2)
        g = norm([startx,starty]-[N(1,i),N(2,i)]);   %计算当前代价frontier(4,1)+norm([mx,my],[N(1,i)-N(2,i)])
        f = g + abs(N(1,i)-endx)+abs(N(2,i)-endy);
        frontier{i,1} = f;
        frontier{i,2} = N(1,i);
        frontier{i,3} = N(2,i);
        frontier{i,4} = g;
        frontier{i,5} = [[startx,starty];[N(1,i),N(2,i)]];     %将当前节点设置为父亲
    end
    frontier = sortrows(frontier,1);

    %-----待插入待边界列表的列表-----%
    temp_frontier = cell(0,5);
    % 更新待探索列表
    while isempty(frontier) == 0
        % 1.将当前节点移入already_frontier
        current = frontier(1,:);
        already_frontier(end+1,:) = frontier(1,:);    %当前节点加入already_frontier
        frontier(1,:) = [];     %删除当前节点（frontier的第一行）

        % 当前节点坐标
        mx = current{1,2};
        my = current{1,3};
        if show_flag == 2
            plot(current{1,2},current{1,3},'g*');   %当前节点标绿色*号
        end

        % 2.查找当前节点边界(忽略already_frontier中的)
        N = find_frontier(mx,my,Estart_x,Estart_x+Weight,Estart_y,Estart_y+High,C,already_frontier);
        % 循环当前节点边界
        for i = 1:size(N,2)
            % 3.判断边界节点是否在frontier中
            b = find([frontier{:,2}]==N(1,i));
            a = b([frontier{b,3}]==N(2,i));
            g = current{1,4} + norm([mx,my]-[N(1,i),N(2,i)]);
            f = g + abs(N(1,i)-endx)+abs(N(2,i)-endy);
            % 3.1 如果边界节点已经在frontier中，检查其当前代价是否更小
            if a > 0
                if frontier{a,4} > g   %如果经过边界的当前代价更小，则重新计算g、f，并更换路径
                    frontier{a,5} = [current{1,5};[N(1,i),N(2,i)]];
                    frontier{a,4} = g;  %重新计算当前代价
                    frontier{a,1} = f;  %重新计算总代价
                end
            % 3.2 如果边界节点没有加入frontiner则加入，成为待探测节点
            else
                temp{1,1} = f;
                temp{1,2} = N(1,i);
                temp{1,3} = N(2,i);
                temp{1,4} = g;
                temp{1,5} = [current{1,5};[N(1,i),N(2,i)]];     %将当前节点设置为父亲
                %frontier = [temp;frontier];
                temp_frontier = [temp;temp_frontier];   %合法边界插入到frontier的第二列(因为第一列之后要移动到already_frontier)
                if show_flag == 2
                    plot(N(1,i),N(2,i),'bs');     %正方形(表示待检测节点)
                end
            end
        end

        % 4.如果新加入already_frontier的节点是终点，则跳出循环
        if already_frontier{end,2}==endx && already_frontier{end,3}==endy
            plot(already_frontier{end,5}(:,1),already_frontier{end,5}(:,2),'r-','LineWidth',2);   %画出最终路径
            drawnow;
            break; 
        end

        % 5.插入排序
        for i = 1:size(temp_frontier,1)
            j = 0;
            while j <= size(frontier,1) + 1
                j = j + 1;
                if j == size(frontier,1) + 1
                    frontier = [frontier;temp_frontier(i,:)];
                    break;
                end
                if temp_frontier{i,1} < frontier{j,1}
                    if j == 1
                        frontier = [temp_frontier(i,:);frontier];
                    else
                        frontier = [frontier(1:j-1,:);temp_frontier(i,:);frontier(j:end,:)];
                    end
                    break;
                end
            end
        end
        temp_frontier = cell(0,5);    %清空临时列表
    
        %matlab函数排序(较慢)
        %frontier = sortrows(frontier,1);

        if show_flag == 1 || show_flag == 2
            p = plot(already_frontier{end,5}(:,1),already_frontier{end,5}(:,2),'r-','LineWidth',2);
            drawnow;
            delete(p);
        end
    end
    dis = already_frontier{end,1};     %总路程
    road = already_frontier{end,5};    %最短路径
end

