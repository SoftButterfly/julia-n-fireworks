% ******************************************************************************
% Block 0:GUI Defaults
% ******************************************************************************
function varargout = JuliaNFireworks(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @juliaNFireworks_OpeningFcn, ...
                       'gui_OutputFcn',  @juliaNFireworks_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);

    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
return

function juliaNFireworks_OpeningFcn(hObject, ~, handles, varargin)
    try
        % --- Set handles struct -----------------------------------------------
        handles.output = hObject;
        handles.children = [];
        handles.julia = struct('Lim', [], ...
                               'XData', [], ...
                               'YData', [], ...
                               'ZData', [], ...
                               'Power', [], ...
                               'Constant', [], ...
                               'Iterations', [], ...
                               'Resolution', [], ...
                               'Colormap', []);

        guidata(hObject, handles);

        % --- Set up GUI -------------------------------------------------------
        set(handles.edit1, 'String', ['Z^(', ...
                                      num2str(get(handles.slider4, 'Value')), ...
                                      ') + (', ...
                                      num2str(get(handles.slider2, 'Value') + ...
                                              get(handles.slider3, 'Value')*1i), ...
                                      ')'])

        set(handles.edit2, 'String', num2str(get(handles.slider1, 'Value')))

        set(handles.edit3, 'String', num2str(get(handles.slider2, 'Value') + ...
                                             get(handles.slider3, 'Value')*1i))

        set(handles.edit4, 'String', num2str(get(handles.slider4, 'Value')))

        cmaps = get(handles.popupmenu3, 'String');
        cvalue = get(handles.popupmenu3, 'Value');
        cmap = lower(cmaps{cvalue});

        set(handles.edit5, 'String', ['colormap(', ...
                                      cmap, ...
                                      '(', ...
                                      num2str(get(handles.slider1, 'Value')), ...
                                      '))'])

        % --- Set up Julia Set Data --------------------------------------------
        handles.julia.Colormap = eval(['flipud(', ...
                                       get(handles.edit5, 'String'), ...
                                       ')']);

        handles.julia.Resolution = 500;

        handles.julia.Iterations = get(handles.slider1, 'Value');

        handles.julia.Constant = get(handles.slider2, 'Value') + ...
                                 get(handles.slider3, 'Value')*1i;

        handles.julia.Power = get(handles.slider4, 'Value');

        handles.julia.ZData = zeros(handles.julia.Resolution);

        handles.julia.Lim = [-1.5, 1.5, -1.5, 1.5];

        handles.julia.YData = linspace(handles.julia.Lim(3), ...
                                       handles.julia.Lim(4), ...
                                       handles.julia.Resolution);

        handles.julia.XData = linspace(handles.julia.Lim(1), ...
                                       handles.julia.Lim(2), ...
                                       handles.julia.Resolution);

        guidata(hObject, handles);
    catch Exception
        disp(getReport(Exception))
        
        delete(hObject);
    end
return

function varargout = juliaNFireworks_OutputFcn(hObject, ~, handles)
    try
        varargout{1} = handles.output;
    catch
        varargout{1} = 0;
        
        delete(hObject)
    end
return

function figure1_CloseRequestFcn(hObject, ~, handles)
    try
        if ~isempty(handles.children)
            for h = handles.children
                try 
                    delete(h)
                catch Exception
                    disp(getReport(Exception))
                end
            end
        end
        
        delete(hObject);
    catch Exception
        disp(getReport(Exception))
        
        delete(hObject);
    end
return

% ******************************************************************************
% Block 1: Samples and expressions
% ******************************************************************************
function popupmenu1_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
return

function popupmenu1_Callback(hObject, ~, handles)
    try
        Value = get(hObject, 'Value');
        
        dat = [  0, -1.5000000-1.50000000i, 0;
                50, -0.7500000-0.35000000i, 2;
               200, -0.4000000+0.60000000i, 2;
               100, +0.2850000+0.01000000i, 2;
                50, +0.4500000+0.14280000i, 2;
               100, -0.7017000+0.38420000i, 2;
               100, -0.8350000-0.23210000i, 2;
               200, -0.8000000+0.15600000i, 2;
               100, -0.2365000-0.67210000i, 2;
                50, +0.2311000+0.60680000i, 2;
               100, -0.7322000-0.26280000i, 2;
               100, -0.7954300+0.17308000i, 2;
               200, -0.5125100+0.52129000i, 2;
               100, -0.8100000-0.17950000i, 2;
               200, +0.3623700+0.32000000i, 2;
               200, -0.4959345-0.52287731i, 2;
               200, -0.4942345+0.52287731i, 2];

        
        dat = dat(Value,:);
        
        set(handles.slider1, 'Value', real(dat(1)))
        set(handles.slider2, 'Value', real(dat(2)))
        set(handles.slider3, 'Value', imag(dat(2)))
        set(handles.slider4, 'Value', real(dat(3)))
        
        if abs(real(dat(2))) < 0.58
            set(handles.text4, 'Visible', 'off')
        else
            set(handles.text4, 'Visible', 'on')
        end
        
        if abs(imag(dat(2))) < 0.58
            set(handles.text5, 'Visible', 'off')
        else
            set(handles.text5, 'Visible', 'on')
        end
        
        set(handles.edit1, 'String', ['Z^(', ...
                                      num2str(get(handles.slider4, 'Value')), ...
                                      ') + (', ...
                                      num2str(get(handles.slider2, 'Value') + ...
                                              get(handles.slider3, 'Value')*1i), ...
                                      ')'])

        set(handles.edit2, 'String', num2str(get(handles.slider1, 'Value')))

        set(handles.edit3, 'String', num2str(get(handles.slider2, 'Value') + ...
                                             get(handles.slider3, 'Value')*1i))

        set(handles.edit4, 'String', num2str(get(handles.slider4, 'Value')))
        
        cmaps = get(handles.popupmenu3, 'String');
        cvalue = get(handles.popupmenu3, 'Value');
        cmap = lower(cmaps{cvalue});

        set(handles.edit5, 'String', ['colormap(', ...
                                      cmap, ...
                                      '(', ...
                                      num2str(get(handles.slider1, 'Value')), ...
                                      '))'])
        
    catch Exception
        disp(getReport(Exception))
    end
return

function edit1_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
return

% ******************************************************************************
% Block 3:Iterations
% ******************************************************************************
function edit2_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
return

function edit2_Callback(hObject, ~, handles)
    try
        Value = floor(str2double(get(hObject, 'String')));

        if isempty(Value)
            set(hObject, 'String', num2str(get(handles.slider1, 'Min')))
            set(handles.slider1, 'Value', get(handles.slider1, 'Min'))
        elseif Value > get(handles.slider1, 'Max')
            set(hObject, 'String', num2str(get(handles.slider1, 'Max')))
            set(handles.slider1, 'Value', get(handles.slider1, 'Max'))
        elseif Value < get(handles.slider1, 'Min')
            set(hObject, 'String', num2str(get(handles.slider1, 'Min')))
            set(handles.slider1, 'Value', get(handles.slider1, 'Min'))
        else
            set(hObject, 'String', num2str(Value))
            set(handles.slider1, 'Value', Value)
        end
        
        cmaps = get(handles.popupmenu3, 'String');
        cvalue = get(handles.popupmenu3, 'Value');
        cmap = lower(cmaps{cvalue});
        
        if cvalue == length(cmaps)
            set(handles.edit5, 'String', 'colormap(bone(256))')
        elseif Value < 256
            set(handles.edit5, 'String', ['colormap(', ...
                                          cmap, ...
                                          '(', ...
                                          num2str(Value), ...
                                          '))'])
        else
            set(handles.edit5, 'String', ['colormap(', ...
                                          cmap, ...
                                          ')'])
        end
        
        % --- Update Julia Set Data --------------------------------------------
        handles.julia.Iterations = Value;
        guidata(handles.output, handles);
        %fprintf('Change handles.julia.Iterations: %s\n', num2str(Value));
    catch Exception
        disp(getReport(Exception))
    end
return

function slider1_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), ...
               get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
return

function slider1_Callback(hObject, ~, handles)
    try
        Value = floor(get(hObject, 'Value'));

        set(hObject, 'Value', Value)
        set(handles.edit2, 'String', num2str(Value))

        cmaps = get(handles.popupmenu3, 'String');
        cvalue = get(handles.popupmenu3, 'Value');
        cmap = lower(cmaps{cvalue});
        
        if cvalue == length(cmaps)
            set(handles.edit5, 'String', 'colormap(bone(256))')
        elseif Value < 256
            set(handles.edit5, 'String', ['colormap(', ...
                                          cmap, ...
                                          '(', ...
                                          num2str(Value), ...
                                          '))'])
        else
            set(handles.edit5, 'String', ['colormap(', ...
                                          cmap, ...
                                          ')'])
        end
    catch Exception
        disp(getReport(Exception))
    end
return

% ******************************************************************************
% Block 3: Constant
% ******************************************************************************
function edit3_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
return

function edit3_Callback(hObject, ~, handles)
    try
        ReValue = real(str2double(get(hObject, 'String')));
        ImValue = imag(str2double(get(hObject, 'String')));

        if isempty(ReValue)
            ReValue = 0;
        elseif ReValue > get(handles.slider2, 'Max')
            ReValue = get(handles.slider2, 'Max');
        elseif ReValue < get(handles.slider2, 'Min')
            ReValue = get(handles.slider2, 'Min');
        end

        if isempty(ImValue)
            ImValue = 0;
        elseif ImValue > get(handles.slider3, 'Max')
            ImValue = get(handles.slider3, 'Max');
        elseif ImValue < get(handles.slider3, 'Min')
            ImValue = get(handles.slider3, 'Min');
        end

        Value = ReValue + ImValue*1i;

        set(hObject, 'String', num2str(Value))
        set(handles.slider2, 'Value', ReValue)
        set(handles.slider3, 'Value', ImValue)

        if abs(ReValue) < 0.4
            set(handles.text4, 'Visible', 'off')
        else
            set(handles.text4, 'Visible', 'on')
        end

        if abs(ImValue) < 0.4
            set(handles.text5, 'Visible', 'off')
        else
            set(handles.text5, 'Visible', 'on')
        end

        set(handles.edit1, 'String', ['Z^(', ...
                                     num2str(get(handles.slider4, 'Value')), ...
                                     ') + (', ...
                                     num2str(get(handles.slider2, 'Value') + ...
                                             get(handles.slider3, 'Value')*1i), ...
                                     ')'])

        % --- Update Julia Set Data --------------------------------------------
        handles.julia.Constant = Value;
        guidata(handles.output, handles);
        %fprintf('Change handles.julia.Constant: %s\n', num2str(Value));
    catch Exception
        disp(getReport(Exception))
    end
return

function slider2_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), ...
               get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
return

function slider2_Callback(hObject, ~, handles)
    try
        ReValue = get(hObject, 'Value');
        ImValue = get(handles.slider3, 'Value');

        Value = ReValue + ImValue*1i;

        if abs(ReValue) < 0.58
            set(handles.text4, 'Visible', 'off')
        else
            set(handles.text4, 'Visible', 'on')
        end

        set(handles.edit3, 'String', num2str(Value))

        set(handles.edit1, 'String', ['Z^(', ...
                                     num2str(get(handles.slider4, 'Value')), ...
                                     ') + (', ...
                                     num2str(get(handles.slider2, 'Value') + ...
                                             get(handles.slider3, 'Value')*1i), ...
                                     ')'])

        % --- Update Julia Set Data --------------------------------------------
        handles.julia.Constant = Value;
        guidata(handles.output, handles);
        %fprintf('Change handles.julia.Constant: %s\n', num2str(Value));
    catch Exception
        disp(getReport(Exception))
    end
return

function slider3_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), ...
               get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
return

function slider3_Callback(hObject, ~, handles)
    try
        ReValue = get(handles.slider2, 'Value');
        ImValue = get(hObject, 'Value');

        Value = ReValue + ImValue*1i;

        if abs(ImValue) < 0.58
            set(handles.text5, 'Visible', 'off')
        else
            set(handles.text5, 'Visible', 'on')
        end

        set(handles.edit3, 'String', num2str(Value))

        set(handles.edit1, 'String', ['Z^(', ...
                                     num2str(get(handles.slider4, 'Value')), ...
                                     ') + (', ...
                                     num2str(get(handles.slider2, 'Value') + ...
                                             get(handles.slider3, 'Value')*1i), ...
                                     ')'])

        % --- Update Julia Set Data --------------------------------------------
        handles.julia.Constant = Value;
        guidata(handles.output, handles);
        %fprintf('Change handles.julia.Constant: %s\n', num2str(Value));
    catch Exception
        disp(getReport(Exception))
    end
return

% ******************************************************************************
% Block 4: Power
% ******************************************************************************
function edit4_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
return

function edit4_Callback(hObject, ~, handles)
    try
        Value = floor(str2double(get(hObject, 'String')));

        if isempty(Value)
            set(hObject, 'String', num2str(get(handles.slider4, 'Min')))
            set(handles.slider4, 'Value', get(handles.slider4, 'Min'))
        elseif Value > get(handles.slider4, 'Max')
            set(hObject, 'String', num2str(get(handles.slider4, 'Max')))
            set(handles.slider4, 'Value', get(handles.slider4, 'Max'))
        elseif Value < get(handles.slider4, 'Min')
            set(hObject, 'String', num2str(get(handles.slider4, 'Min')))
            set(handles.slider4, 'Value', get(handles.slider4, 'Min'))
        else
            set(hObject, 'String', num2str(Value))
            set(handles.slider4, 'Value', Value)
        end

        set(handles.edit1, 'String', ['Z^(', ...
                                     num2str(get(handles.slider4, 'Value')), ...
                                     ') + (', ...
                                     num2str(get(handles.slider2, 'Value') + ...
                                             get(handles.slider3, 'Value')*1i), ...
                                     ')'])

        % --- Update Julia Set Data --------------------------------------------
        handles.julia.Power = Value;
        guidata(handles.output, handles);
        %fprintf('Change handles.julia.Power: %s\n', num2str(Value))
    catch Exception
        disp(getReport(Exception))
    end
return

function slider4_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), ...
               get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
return

function slider4_Callback(hObject, ~, handles)
    try
        Value = floor(get(hObject, 'Value'));

        set(hObject, 'Value', Value)
        set(handles.edit4, 'String', num2str(Value))

        set(handles.edit1, 'String', ['Z^(', ...
                                     num2str(get(handles.slider4, 'Value')), ...
                                     ') + (', ...
                                     num2str(get(handles.slider2, 'Value') + ...
                                             get(handles.slider3, 'Value')*1i), ...
                                     ')'])

        % --- Update Julia Set Data --------------------------------------------
        handles.julia.Power = Value;
        guidata(handles.output, handles);
        %fprintf('Change handles.julia.Power: %s\n', num2str(Value))
    catch Exception
        disp(getReport(Exception))
    end
return

% ******************************************************************************
% Block 5: Resolution and colormap
% ******************************************************************************
function popupmenu2_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
return

function popupmenu2_Callback(hObject, ~, handles)
    
    try
        pause(0.1)
        
        if get(hObject, 'Value') == 1
            Value = 500;
        elseif get(hObject, 'Value') == 2
            Value = 1000;
        elseif get(hObject, 'Value') == 3
            Value = 2000;
        end
        
        % --- Update Julia Set Data --------------------------------------------
        handles.julia.Resolution = Value;
        guidata(handles.output, handles);
        
        if ~isempty(get(handles.axes1, 'Children'))
            make_julia_set(handles)
        end
    catch Exception
        disp(getReport(Exception))
    end
    

return

function popupmenu3_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
return

function popupmenu3_Callback(hObject, ~, handles)
    try
        Value = get(handles.slider1, 'Value');
        
        cmaps = get(hObject, 'String');
        cvalue = get(hObject, 'Value');
        cmap = lower(cmaps{cvalue});
        
        if cvalue == length(cmaps)
            set(handles.edit5, 'String', 'colormap(bone(256))')
        elseif Value < 256
            set(handles.edit5, 'String', ['colormap(', ...
                                          cmap, ...
                                          '(', ...
                                          num2str(Value), ...
                                          '))'])
        else
            set(handles.edit5, 'String', ['colormap(', ...
                                          cmap, ...
                                          ')'])
        end
        
        if ~isempty(get(handles.axes1, 'Children'))
            handles.julia.Colormap = eval(['flipud(' get(handles.edit5, 'String') ')']);
            colormap(handles.julia.Colormap);
        end
    catch Exception
        disp(getReport(Exception))
    end
return

function edit5_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
                       get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
return

function edit5_Callback(hObject, ~, handles)
    try
        if ~isempty(get(handles.axes1, 'Children'))
            handles.julia.Colormap = eval(['flipud(' get(hObject, 'String') ')']);
            colormap(handles.julia.Colormap);
        end
    catch        
        set(handles.popupmenu3, 'Value', 1)
        
        Value = get(handles.slider1, 'Value');
        
        cmaps = get(handles.popupmenu3, 'String');
        cvalue = get(handles.popupmenu3, 'Value');
        cmap = lower(cmaps{cvalue});
        
        if Value < 256
            set(handles.edit5, 'String', ['colormap(', ...
                                          cmap, ...
                                          '(', ...
                                          num2str(Value), ...
                                          '))'])
        else
            set(handles.edit5, 'String', ['colormap(', ...
                                          cmap, ...
                                          ')'])
        end
        
        if ~isempty(get(handles.axes1, 'Children'))
            handles.julia.Colormap = eval(['flipud(' get(handles.edit5, 'String') ')']);
            colormap(handles.julia.Colormap);
        end
    end
return

function pushbutton1_Callback(~, ~, handles)
    try
        if ~isempty(get(handles.axes1, 'Children'))
            cmapeditor
        end
    catch Exception
        disp(getReport(Exception))
    end
return

% ******************************************************************************
% Block 6: Cutomize colormap, Generate julia set, Zoom, and Save
% ******************************************************************************
function pushbutton2_Callback(~, ~, handles)
    try
        make_julia_set(handles)
    catch Exception
        disp(getReport(Exception))
    end
return

function togglebutton3_Callback(hObject, ~, handles)
    try
        if ~isempty(get(handles.axes1, 'Children'))
            if get(hObject, 'Value')
                if get(handles.togglebutton4, 'Value')
                    set(handles.togglebutton4, 'Value', 0)
                end

                h = zoom(handles.figure1);

                set(h,'ActionPostCallback',@postZoom);

                set(h, 'Enable','on');
                set(h, 'Direction', 'in');
            else
                zoom off
            end
        end
    catch Exception
        disp(getReport(Exception))
    end    
return

function togglebutton4_Callback(hObject, ~, handles)
    try
        if ~isempty(get(handles.axes1, 'Children'))
            if get(hObject, 'Value')
                if get(handles.togglebutton3, 'Value')
                    set(handles.togglebutton3, 'Value', 0)
                end

                h = zoom(handles.figure1);

                set(h,'ActionPostCallback',@postZoom);

                set(h, 'Enable','on');
                set(h, 'Direction', 'out');
            else
                zoom off
            end
        end
    catch Exception
        disp(getReport(Exception))
    end    
return

function pushbutton5_Callback(~, ~, handles)
    try
        if ~isempty(get(handles.axes1, 'Children'))
            set(handles.togglebutton3, 'Value', 0)
            set(handles.togglebutton4, 'Value', 0)
            
            handles.julia.Lim = [-1.5, 1.5, -1.5, 1.5];
        
            make_julia_set(handles)
        
            guidata(handles.output, handles);
        end
    catch Exception
        disp(getReport(Exception))
    end
return

function pushbutton6_Callback(~, ~, handles)
    try
        filename = ['Julia_' timestamp(30) '.png'];

        [filename, filepath] = uiputfile('*.png', 'Save image', filename);

        if ~isequal(filename, 0) && ~isequal(filename, 0)
            handles.julia.Colormap = get(handles.figure1, 'Colormap');

            imwrite(handles.julia.ZData, handles.julia.Colormap, ...
                    fullfile(filepath, filename), 'png', ...
                    'BitDepth', 8);
        end
    catch Exception
        disp(getReport(Exception))
    end
return


% ******************************************************************************
% Block 7: Help and About
% ******************************************************************************
function pushbutton7_Callback(~, ~, ~)
    disp('Help me to make documentation T_T')
return

function pushbutton8_Callback(~, ~, ~)
    disp('Developed By Martin Josemaria Vuelta Rojas ;)')
return


% ******************************************************************************
% Block 8: Useful functions
% ******************************************************************************
function make_julia_set(handles)
    % Updating Julia Set Structure fields
    if isempty(get(handles.axes1, 'Children'))
        handles.julia.Colormap = eval(['flipud(' ...
                                       get(handles.edit5, 'String') ...
                                       ')']);
    else
        handles.julia.Colormap = get(handles.figure1, 'Colormap');
    end
    
    handles.julia.Iterations = get(handles.slider1, 'Value');

    handles.julia.Constant = get(handles.slider2, 'Value') + ...
                             get(handles.slider3, 'Value')*1i;

    handles.julia.Power = get(handles.slider4, 'Value');
    
    handles.julia.ZData = ones(handles.julia.Resolution);
    
    handles.julia.YData = linspace(handles.julia.Lim(3), ...
                                   handles.julia.Lim(4), ...
                                   handles.julia.Resolution);

    handles.julia.XData = linspace(handles.julia.Lim(1), ...
                                   handles.julia.Lim(2), ...
                                   handles.julia.Resolution);
    
    if isempty(get(handles.axes1, 'Children'))
        message = 'Generating Julia set ...';
    else
        message = 'Updating plot ...';
    end
    
    Progress = waitbar(0, message, ...
                       'Name', 'Data processing', ...
                       'Color', 'white', ...
                       'WindowStyle', 'modal', ...
                       'CreateCancelBtn', 'setappdata(gcbf, ''canceling'', 1)');
	
    setappdata(Progress, 'canceling', 0)
    
    handles.children = [handles.children Progress];
                               
    guidata(handles.output, handles);

    [X, Y] = meshgrid(handles.julia.XData, handles.julia.YData);
    Z = X + Y*1i;
    
    V = floor(handles.julia.Iterations/10);
    C = handles.julia.Constant;
    N = handles.julia.Iterations;
    
    for n = 1:N
        if ~mod(n,V)
            waitbar(n/N, Progress, sprintf('%s %.2f%%',message, 100*n/N))
        end
        
        Z = (Z.^handles.julia.Power) + C;
        
        handles.julia.ZData(abs(Z) < 2) = n;
    end
    
    waitbar(1, Progress, sprintf('%s %.2f%%',message, 100.00))
    pause(0.1)
    delete(Progress)
    
    handles.children = [];
    guidata(handles.output, handles);
    
    colormap(handles.julia.Colormap);
    hImage = image(handles.julia.XData, ...
                   handles.julia.YData, ...
                   handles.julia.ZData);
    
	box on
    axis tight off
    
    pImage = get(hImage, 'Parent');
    
    if pImage ~= handles.axes1
        set(hImage, 'Parent', handles.axes1)
        delete(pImage)
    end
return

function postZoom(figHandles, ~)
    try
        handles = guidata(figHandles);
        
        if ~isempty(get(handles.axes1, 'Children'))
            X = get(handles.axes1, 'XLim');
            Y = get(handles.axes1, 'YLim');
            
            handles.julia.Lim = [X(1) X(2) Y(1) Y(2)];
            
            guidata(handles.output, handles);
            
            make_julia_set(handles)
        end
    catch Exception
        disp(getReport(Exception))
    end
return

function timestr = timestamp(format)
    timestr = clock;
    timestr = datenum(timestr);
    timestr = datestr(timestr, format);
return