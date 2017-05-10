<GameFile>
  <PropertyGroup Name="LaunchSceneCCS" Type="Scene" ID="11a0ff3e-8d9f-4b55-95a0-86e58fb59359" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Scene" Tag="8" ctype="GameNodeObjectData">
        <Size X="1280.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="Panel_1" ActionTag="-1601747889" Tag="9" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" PercentWidthEnable="True" PercentHeightEnable="True" PercentWidthEnabled="True" PercentHeightEnabled="True" LeftMargin="1.5360" RightMargin="-1.5360" TopMargin="-1.2240" BottomMargin="1.2240" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" LeftEage="422" RightEage="422" TopEage="237" BottomEage="237" Scale9OriginX="422" Scale9OriginY="237" Scale9Width="436" Scale9Height="246" ctype="PanelObjectData">
            <Size X="1280.0000" Y="720.0000" />
            <Children>
              <AbstractNodeData Name="ArmatureNode_2" ActionTag="1229633417" Tag="11" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="640.0000" RightMargin="640.0000" TopMargin="360.0000" BottomMargin="360.0000" IsLoop="True" IsAutoPlay="True" CurrentAnimationName="ani_01" ctype="ArmatureNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint />
                <Position X="640.0000" Y="360.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="Normal" Path="frame_res/anim/kog_loadingani/kog_loadingani.ExportJson" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="Panel_Progress" ActionTag="531432194" Tag="15" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="33.3888" RightMargin="33.3888" TopMargin="515.9600" BottomMargin="4.0400" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="1213.2224" Y="200.0000" />
                <Children>
                  <AbstractNodeData Name="tip_text" ActionTag="415761770" Tag="16" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="516.6112" RightMargin="516.6112" TopMargin="115.5100" BottomMargin="54.4900" FontSize="30" LabelText="获取配置中.." ShadowOffsetX="1.0000" ShadowOffsetY="-1.0000" ShadowEnabled="True" ctype="TextObjectData">
                    <Size X="180.0000" Y="30.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="606.6112" Y="69.4900" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="170" G="202" B="229" />
                    <PrePosition X="0.5000" Y="0.3474" />
                    <PreSize X="0.1484" Y="0.1500" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="0" G="0" B="0" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Image_1" ActionTag="1853434472" Tag="13" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="120.6112" RightMargin="120.6112" TopMargin="74.8000" BottomMargin="91.2000" LeftEage="270" RightEage="270" TopEage="8" BottomEage="8" Scale9OriginX="270" Scale9OriginY="8" Scale9Width="432" Scale9Height="18" ctype="ImageViewObjectData">
                    <Size X="972.0000" Y="34.0000" />
                    <Children>
                      <AbstractNodeData Name="download_progress_bar" ActionTag="2083003928" Tag="17" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" PercentHeightEnable="True" PercentHeightEnabled="True" LeftMargin="2.5000" RightMargin="2.5000" ProgressInfo="26" ctype="LoadingBarObjectData">
                        <Size X="967.0000" Y="34.0000" />
                        <Children>
                          <AbstractNodeData Name="progress_arrow" ActionTag="1956385283" Tag="9" IconVisible="False" PositionPercentYEnabled="True" RightMargin="967.0000" TopMargin="17.0000" BottomMargin="17.0000" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ComboBoxIndex="1" ColorAngle="90.0000" ctype="PanelObjectData">
                            <Size X="0.0000" Y="0.0000" />
                            <Children>
                              <AbstractNodeData Name="ArmatureNode_1" ActionTag="658646553" Tag="10" IconVisible="True" LeftMargin="-43.0000" RightMargin="43.0000" IsLoop="True" IsAutoPlay="True" CurrentAnimationName="ani_02" ctype="ArmatureNodeObjectData">
                                <Size X="0.0000" Y="0.0000" />
                                <AnchorPoint />
                                <Position X="-43.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition />
                                <PreSize X="0.0000" Y="0.0000" />
                                <FileData Type="Normal" Path="frame_res/anim/kog_loadingani/kog_loadingani.ExportJson" Plist="" />
                              </AbstractNodeData>
                            </Children>
                            <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                            <Position Y="17.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition Y="0.5000" />
                            <PreSize X="0.0000" Y="0.0000" />
                            <SingleColor A="255" R="150" G="200" B="255" />
                            <FirstColor A="255" R="150" G="200" B="255" />
                            <EndColor A="255" R="255" G="255" B="255" />
                            <ColorVector ScaleY="1.0000" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="486.0000" Y="17.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.9949" Y="1.0000" />
                        <ImageFileData Type="Normal" Path="frame_res/bb_loading_jzt.png" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="progress_text" ActionTag="337154462" VisibleForFrame="False" Tag="6" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="471.0000" RightMargin="471.0000" TopMargin="2.0000" BottomMargin="2.0000" FontSize="30" LabelText="0%" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="30.0000" Y="30.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="486.0000" Y="17.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.0309" Y="0.8824" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="606.6112" Y="108.2000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5410" />
                    <PreSize X="0.8012" Y="0.1700" />
                    <FileData Type="Normal" Path="frame_res/bb_loading_jztd.png" Plist="" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" />
                <Position X="640.0000" Y="4.0400" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.0056" />
                <PreSize X="0.9478" Y="0.2778" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="641.5360" Y="361.2240" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5012" Y="0.5017" />
            <PreSize X="1.0000" Y="1.0000" />
            <FileData Type="Normal" Path="frame_res/kog_bg.jpg" Plist="" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>