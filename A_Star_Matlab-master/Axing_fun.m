%% A���㷨����
% show_flag: ��ʾ���̱�־λ,0:ֱ����ʾ  1:��ʾ��������(�������߽�)  2:��ʾ��������(�����߽�)
function [dis,road] = Axing_fun(startx,starty,endx,endy,Estart_x,Estart_y,Weight,High,C,show_flag)
    %-----��̽���߽��б�-----%
    f = 0 + abs(startx-endx)+abs(starty-endy);  %��ʼ�ĵ�ǰ����Ϊ0
    already_frontier = {f,startx,starty,0,[startx,starty]};

    %-----��̽���߽��б�-----%
    % (��һ�����ܴ��ۣ��ڶ����Ǻ����꣬�������������꣬�������ǵ�ǰ���ۣ���������·��)
    frontier = cell(0,5);
    % Ѱ���ھӵ�
    N = find_frontier(startx,starty,Estart_x,Estart_x+Weight,Estart_y,Estart_y+High,C,already_frontier);
    % ѭ����ǰ�߽��ھ�
    for i = 1:size(N,2)
        g = norm([startx,starty]-[N(1,i),N(2,i)]);   %���㵱ǰ����frontier(4,1)+norm([mx,my],[N(1,i)-N(2,i)])
        f = g + abs(N(1,i)-endx)+abs(N(2,i)-endy);
        frontier{i,1} = f;
        frontier{i,2} = N(1,i);
        frontier{i,3} = N(2,i);
        frontier{i,4} = g;
        frontier{i,5} = [[startx,starty];[N(1,i),N(2,i)]];     %����ǰ�ڵ�����Ϊ����
    end
    frontier = sortrows(frontier,1);

    %-----��������߽��б���б�-----%
    temp_frontier = cell(0,5);
    % ���´�̽���б�
    while isempty(frontier) == 0
        % 1.����ǰ�ڵ�����already_frontier
        current = frontier(1,:);
        already_frontier(end+1,:) = frontier(1,:);    %��ǰ�ڵ����already_frontier
        frontier(1,:) = [];     %ɾ����ǰ�ڵ㣨frontier�ĵ�һ�У�

        % ��ǰ�ڵ�����
        mx = current{1,2};
        my = current{1,3};
        if show_flag == 2
            plot(current{1,2},current{1,3},'g*');   %��ǰ�ڵ����ɫ*��
        end

        % 2.���ҵ�ǰ�ڵ�߽�(����already_frontier�е�)
        N = find_frontier(mx,my,Estart_x,Estart_x+Weight,Estart_y,Estart_y+High,C,already_frontier);
        % ѭ����ǰ�ڵ�߽�
        for i = 1:size(N,2)
            % 3.�жϱ߽�ڵ��Ƿ���frontier��
            b = find([frontier{:,2}]==N(1,i));
            a = b([frontier{b,3}]==N(2,i));
            g = current{1,4} + norm([mx,my]-[N(1,i),N(2,i)]);
            f = g + abs(N(1,i)-endx)+abs(N(2,i)-endy);
            % 3.1 ����߽�ڵ��Ѿ���frontier�У�����䵱ǰ�����Ƿ��С
            if a > 0
                if frontier{a,4} > g   %��������߽�ĵ�ǰ���۸�С�������¼���g��f��������·��
                    frontier{a,5} = [current{1,5};[N(1,i),N(2,i)]];
                    frontier{a,4} = g;  %���¼��㵱ǰ����
                    frontier{a,1} = f;  %���¼����ܴ���
                end
            % 3.2 ����߽�ڵ�û�м���frontiner����룬��Ϊ��̽��ڵ�
            else
                temp{1,1} = f;
                temp{1,2} = N(1,i);
                temp{1,3} = N(2,i);
                temp{1,4} = g;
                temp{1,5} = [current{1,5};[N(1,i),N(2,i)]];     %����ǰ�ڵ�����Ϊ����
                %frontier = [temp;frontier];
                temp_frontier = [temp;temp_frontier];   %�Ϸ��߽���뵽frontier�ĵڶ���(��Ϊ��һ��֮��Ҫ�ƶ���already_frontier)
                if show_flag == 2
                    plot(N(1,i),N(2,i),'bs');     %������(��ʾ�����ڵ�)
                end
            end
        end

        % 4.����¼���already_frontier�Ľڵ����յ㣬������ѭ��
        if already_frontier{end,2}==endx && already_frontier{end,3}==endy
            plot(already_frontier{end,5}(:,1),already_frontier{end,5}(:,2),'r-','LineWidth',2);   %��������·��
            drawnow;
            break; 
        end

        % 5.��������
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
        temp_frontier = cell(0,5);    %�����ʱ�б�
    
        %matlab��������(����)
        %frontier = sortrows(frontier,1);

        if show_flag == 1 || show_flag == 2
            p = plot(already_frontier{end,5}(:,1),already_frontier{end,5}(:,2),'r-','LineWidth',2);
            drawnow;
            delete(p);
        end
    end
    dis = already_frontier{end,1};     %��·��
    road = already_frontier{end,5};    %���·��
end

