%% ��ջ���
clc;clear;close all;
%% ��Ŀ�꺯��ͼ��
 figure('Name','Schaffer F6 ������ͼ');
 DrawOptimOBJ();
%% Ŀ�꺯����Լ������
%    objval = OptimOBJ(x) 
%    nvars = 2  ������������
%    Լ������Ϊ��
%    |x(1)| <= 100;            
%    |x(2)| <= 100;                 
c1 = [1,0];
c2 = [0,1];
fun = @OptimOBJ;
cons1 = @(X)(abs(c1*X)<=100);
cons2 = @(X)(abs(c2*X)<=100);
%% ������Ⱥ����
dim = 2;                            % �ռ�ά��=nvars
sizepop = 100;                      % ��ʼ��Ⱥ����
ger = 200;                          % ����������    
xlimit_max = 200*ones(dim,1);       % ����λ�ò�������
xlimit_min = -200*ones(dim,1);
vlimit_max = 2*ones(dim,1);         % �����ٶ�����
vlimit_min = -2*ones(dim,1);
c_1 = 0.5;                          % ԭʼ����Ȩ��
c_2 = 2;                            % ����ѧϰ����
c_3 = 2;                            % Ⱥ��ѧϰ���� 
PV = 10^10;                         % ԭʼ�ͷ�ֵ��Punishment Value��
%% ��Ⱥ��ʼ��
%  ����������ɳ�ʼ��Ⱥλ��
%  Ȼ��������ɳ�ʼ��Ⱥ�ٶ�
%  Ȼ���ʼ��������ʷ���λ�ã��Լ�������ʷ�����Ӧ��
%  Ȼ���ʼ��Ⱥ����ʷ���λ�ã��Լ�Ⱥ����ʷ�����Ӧ��
for i=1:dim
    for j=1:sizepop
        pop_x(i,j) = xlimit_min(i)+(xlimit_max(i) - xlimit_min(i))*rand;  % ��ʼ��Ⱥ��λ��
        pop_v(i,j) = vlimit_min(i)+(vlimit_max(i) - vlimit_min(i))*rand;  % ��ʼ��Ⱥ���ٶ�
    end
end                 
pbest = pop_x;                                % ÿ���������ʷ���λ��
for j=1:sizepop
    if cons1(pop_x(:,j))
        if cons2(pop_x(:,j))
            fitness_pbest(j) = fun(pop_x(:,j));     % ÿ���������ʷ�����Ӧ��
        else
            fitness_pbest(j) = PV/10^8;
        end
    else
        fitness_pbest(j) = PV/10^8;
    end
end
% ��ʼ����Ⱥʱʵ�ʳͷ�ֵ��С���ﵽ���������ռ��Ŀ��
gbest = pop_x(:,1);                           % ��Ⱥ����ʷ���λ��
fitness_gbest = fitness_pbest(1);             % ��Ⱥ����ʷ�����Ӧ��
for j=1:sizepop
    if fitness_pbest(j) < fitness_gbest       % �������Сֵ����Ϊ<; ��������ֵ����Ϊ>;
        gbest = pop_x(:,j);                   % ��¼��Ⱥ����ʷ���λ��
        fitness_gbest=fitness_pbest(j);
    end
end
 
 
%% ����Ⱥ��������
%    �����ٶȲ����ٶȽ��б߽紦��    
%    ����λ�ò���λ�ý��б߽紦��
%    ����Լ�������жϲ���������Ⱥ�����������Ӧ��
%    ����Ӧ���������ʷ�����Ӧ�����Ƚ�
%    ������ʷ�����Ӧ������Ⱥ��ʷ�����Ӧ�����Ƚ�
%    �ٴ�ѭ�������
 
iter = 1;                        %��������
record = zeros(ger, 1);          % ��¼��
while iter <= ger
    for j=1:sizepop
        %    �����ٶȲ����ٶȽ��б߽紦��
        %    ԭʼ����Ȩ�����ӵ������Ժ�����ʹʵ�ʹ���Ȩ��������������Ӷ���С
        pop_v(:,j)= c_1*(-1/ger*iter+1) * pop_v(:,j) + c_2*rand*(pbest(:,j)-pop_x(:,j))+c_3*rand*(gbest-pop_x(:,j));% �ٶȸ���
        for i=1:dim
            if  pop_v(i,j) > vlimit_max(i)
                pop_v(i,j) = vlimit_max(i);
            end
            if  pop_v(i,j) < vlimit_min(i)
                pop_v(i,j) = vlimit_min(i);
            end
        end
        
        %    ����λ�ò���λ�ý��б߽紦��
        pop_x(:,j) = pop_x(:,j) + pop_v(:,j);% λ�ø���
        for i=1:dim           
            if  pop_x(i,j) > xlimit_max(i)
                pop_x(i,j) = xlimit_max(i);
            end
            if  pop_x(i,j) < xlimit_min(i)
                pop_x(i,j) = xlimit_min(i);
            end
        end        
  
        %    ����Լ�������жϲ���������Ⱥ�����������Ӧ��
        if cons1(pop_x(:,j))
            if cons2(pop_x(:,j))
                fitness_pop(j) = fun(pop_x(:,j));   % ��ǰ�������Ӧ��
            else
                fitness_pop(j) = PV/(1+1.05^(-iter+ger/3));
            end
        else
            fitness_pop(j) = PV/(1+1.05^(-iter+ger/3));
        end
        % ������Ӧֵ�����任��
        % ����ʱԭʼ�ͷ�ֵ������Sigmoid�������൱��ʵ�ʳͷ�ֵ���Ŵ������������
        % ������ʼʱ��ʵ�ʳͷ�ֵС�����ƾ���������������Χ��
        % ��������ʱ��ʵ�ʳͷ�ֵ�󣬹����������ӿ������ٶȡ�
        
        %    ����Ӧ���������ʷ�����Ӧ�����Ƚ�
        if fitness_pop(j) < fitness_pbest(j)       % �������Сֵ����Ϊ<; ��������ֵ����Ϊ>; 
            pbest(:,j) = pop_x(:,j);               % ���¸�����ʷ���λ��            
            fitness_pbest(j) = fitness_pop(j);     % ���¸�����ʷ�����Ӧ��
        end   
        
        %    ������ʷ�����Ӧ������Ⱥ��ʷ�����Ӧ�����Ƚ�
        if fitness_pbest(j) < fitness_gbest        % �������Сֵ����Ϊ<; ��������ֵ����Ϊ>; 
            gbest = pbest(:,j);                    % ����Ⱥ����ʷ���λ��  
            fitness_gbest=fitness_pbest(j);        % ����Ⱥ����ʷ�����Ӧ��  
        end    
    end
    
    record(iter) = fitness_gbest;                  % ��Сֵ��¼
    
    iter = iter+1;
 
end
%% ����������
figure('Name','����Ⱥ�Ż��㷨��������');
plot(record);title('��������'); hold on;
disp(['����ֵ��',num2str(fitness_gbest)]);
disp('����ȡֵ��');
fprintf('%.6f\t',gbest);

