% This file defines the Plot class. 
% Each method of the class is a plot function of a different type.

classdef PlotClass
    properties (Constant)
        saveFigures = false;
        figureLeft = 0;
        figureRight = 0.5;
        figureWidth = 0.4;
        figureHeight = 0.5;
        plotLineWidth = 1.5;
        plotColor = 'b';
    end

    methods (Static)
        function line_plot(x, y, titleStr, xlabelStr, ylabelStr, xLim)
        %% Description:
        % This function creates a 2-D line plot of the data in y versus the corresponding values in x
        %% Inputs:
        % x: x axis data points
        % y: y axis data points
        % titleStr: plot title
        % xlabelStr: x axis label
        % ylabelStr: y axis label
        % xLim: limitation for x axis range
            
        %% Code
            figure('Units', 'normalized', 'OuterPosition', [PlotClass.figureLeft, PlotClass.figureRight, PlotClass.figureWidth, PlotClass.figureHeight]);
            plot(x, y, 'LineWidth', PlotClass.plotLineWidth);
            grid on;
            if nargin == 6
                xlim(xLim);
            end
            title(titleStr);
            xlabel(xlabelStr);
            ylabel(ylabelStr);
            
            if PlotClass.saveFigures
                saveas(gcf,strcat(titleStr, '.png'));
            end
        end

        function logarithmic_plot(x, y, titleStr, xlabelStr, ylabelStr, scaleType, holdType, legendStr)
        %% description:
        % This function plots a signal in logarithmic scale
        %% inputs:
        % x: x axis data points
        % y: y axis data points
        % titleStr: plot title
        % xlabelStr: x axis label
        % ylabelStr: y axis label
        % holdType: first, added or last for controlling hold on and off operations
        % legendStr: legend to be added
        
        %% Code
            
            if nargin == 6 || (nargin >= 7 && holdType == "first")
                figure('Units', 'normalized', 'OuterPosition', [PlotClass.figureLeft, PlotClass.figureRight, PlotClass.figureWidth, PlotClass.figureHeight]);
            end

            if scaleType == "loglog"
                loglog(x, y, 'LineWidth', 1.5);
            elseif scaleType == "manual_db"
                plot(x, 20*log10(y), 'LineWidth', PlotClass.plotLineWidth);
            end

            grid on;
            title(titleStr);
            xlabel(xlabelStr);
            ylabel(ylabelStr);

            if nargin == 8
                legend(legendStr);
            elseif nargin >= 7
                if holdType == "first" 
                    hold on
                elseif holdType == "last"
                    hold off
                end
            end

            % if nargin == 8
            %     legend(legendStr);
            % end
            
            if PlotClass.saveFigures
                saveas(gcf,strcat(titleStr, '.png'));
            end
        end

        function histogram_plot(data, xLim, titleStr, xlabelStr, ylabelStr)
        %% Description:
        % This function creates a histogram plot of the data
        %% Inputs:
        % data: data to plot
        % nBins: Number of bins to plot in histogram
        % titleStr: plot title
        % xlabelStr: x axis label
        % ylabelStr: y axis label
        
        %% Code:
            figure('Units', 'normalized', 'OuterPosition', [PlotClass.figureLeft, PlotClass.figureRight, PlotClass.figureWidth, PlotClass.figureHeight]);

            histogram(data);
            xlim(xLim);
            grid on;
            title(titleStr);
            xlabel(xlabelStr);
            ylabel(ylabelStr);

            if PlotClass.saveFigures
                saveas(gcf,strcat(titleStr, '.png'));
            end
        end
    end
end