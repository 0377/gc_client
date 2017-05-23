<GameFile>
  <PropertyGroup Name="MessageLayerCCS" Type="Layer" ID="e801c8d6-4894-49fb-8aa5-47dc7407807f" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="99" ctype="GameLayerObjectData">
        <Size X="1280.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="bg_panel" ActionTag="-1008912223" Tag="37" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" PercentWidthEnable="True" PercentHeightEnable="True" PercentWidthEnabled="True" PercentHeightEnabled="True" TouchEnable="True" ClipAble="False" BackColorAlpha="128" ComboBoxIndex="1" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1280.0000" Y="720.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="640.0000" Y="360.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="1.0000" Y="1.0000" />
            <SingleColor A="255" R="0" G="0" B="0" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="background" ActionTag="-410290435" Tag="100" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="127.5000" RightMargin="127.5000" TopMargin="43.0000" BottomMargin="43.0000" LeftEage="381" RightEage="381" TopEage="220" BottomEage="220" Scale9OriginX="381" Scale9OriginY="220" Scale9Width="263" Scale9Height="194" ctype="ImageViewObjectData">
            <Size X="1025.0000" Y="634.0000" />
            <Children>
              <AbstractNodeData Name="scrollview" ActionTag="2119206469" Tag="101" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="58.2425" RightMargin="54.7575" TopMargin="103.5150" BottomMargin="150.4850" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" IsBounceEnabled="True" ScrollDirectionType="Vertical" ctype="ScrollViewObjectData">
                <Size X="912.0000" Y="380.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="514.2425" Y="340.4850" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5017" Y="0.5370" />
                <PreSize X="0.8898" Y="0.5994" />
                <SingleColor A="255" R="255" G="150" B="100" />
                <FirstColor A="255" R="255" G="150" B="100" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
                <InnerNodeSize Width="1080" Height="380" />
              </AbstractNodeData>
              <AbstractNodeData Name="scrollviewCell" ActionTag="1629026474" Tag="62" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="56.5000" RightMargin="56.5000" TopMargin="123.0000" BottomMargin="457.0000" Scale9Enable="True" LeftEage="263" RightEage="263" TopEage="22" BottomEage="22" Scale9OriginX="263" Scale9OriginY="22" Scale9Width="386" Scale9Height="10" ctype="ImageViewObjectData">
                <Size X="912.0000" Y="54.0000" />
                <Children>
                  <AbstractNodeData Name="label_title" ActionTag="-260239046" Tag="63" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="19.5168" RightMargin="772.4832" TopMargin="12.0000" BottomMargin="12.0000" FontSize="30" LabelText="消息标题" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="120.0000" Y="30.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="19.5168" Y="27.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0214" Y="0.5000" />
                    <PreSize X="0.1316" Y="0.5556" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="label_time" ActionTag="-1170124670" Tag="64" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="828.1968" RightMargin="23.8032" TopMargin="12.0000" BottomMargin="12.0000" FontSize="30" LabelText="时间" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="60.0000" Y="30.0000" />
                    <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                    <Position X="888.1968" Y="27.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="246" G="145" B="0" />
                    <PrePosition X="0.9739" Y="0.5000" />
                    <PreSize X="0.0658" Y="0.5556" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="icon_dot" ActionTag="1215974186" Tag="115" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="888.3800" RightMargin="-5.3800" TopMargin="-10.5000" BottomMargin="35.5000" LeftEage="9" RightEage="9" TopEage="9" BottomEage="9" Scale9OriginX="9" Scale9OriginY="9" Scale9Width="11" Scale9Height="11" ctype="ImageViewObjectData">
                    <Size X="29.0000" Y="29.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="902.8800" Y="50.0000" />
                    <Scale ScaleX="0.8000" ScaleY="0.8000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.9900" Y="0.9259" />
                    <PreSize X="0.0318" Y="0.5370" />
                    <FileData Type="Normal" Path="hall_res/hall/bb_tubiao_hongdian_pressed.png" Plist="" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="512.5000" Y="484.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.7634" />
                <PreSize X="0.8898" Y="0.0852" />
                <FileData Type="Normal" Path="hall_res/notice_service_setting/baobo_tc_xiaoxi_listbg.png" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="loadingbar" ActionTag="1602849009" Tag="102" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="510.5000" RightMargin="510.5000" TopMargin="315.0000" BottomMargin="315.0000" LeftEage="1" RightEage="1" TopEage="1" BottomEage="1" Scale9OriginX="1" Scale9OriginY="1" Scale9Width="2" Scale9Height="2" ctype="ImageViewObjectData">
                <Size X="4.0000" Y="4.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="512.5000" Y="317.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.0039" Y="0.0063" />
                <FileData Type="Normal" Path="hall_res/tongyong/common_transparent.png" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="label_tip" ActionTag="-2035736760" Tag="103" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="440.5000" RightMargin="440.5000" TopMargin="299.0000" BottomMargin="299.0000" FontSize="36" LabelText="暂无消息" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="144.0000" Y="36.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="512.5000" Y="317.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.1405" Y="0.0568" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_confirm" ActionTag="-1017587205" Tag="104" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="369.0000" RightMargin="369.0000" TopMargin="493.0697" BottomMargin="40.9303" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="257" Scale9Height="78" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="287.0000" Y="100.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="512.5000" Y="90.9303" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.1434" />
                <PreSize X="0.2800" Y="0.1577" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Normal" Path="hall_res/tongyong/bb_grxx_queren1.png" Plist="" />
                <PressedFileData Type="Normal" Path="hall_res/tongyong/bb_grxx_queren1.png" Plist="" />
                <NormalFileData Type="Normal" Path="hall_res/tongyong/bb_grxx_queren.png" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_close" ActionTag="-1662294983" Tag="105" IconVisible="False" LeftMargin="963.9545" RightMargin="-5.9546" TopMargin="27.3164" BottomMargin="538.6836" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="37" Scale9Height="46" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="67.0000" Y="68.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="997.4545" Y="572.6836" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.9731" Y="0.9033" />
                <PreSize X="0.0654" Y="0.1073" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Normal" Path="hall_res/tongyong/bb_ty_gb1.png" Plist="" />
                <PressedFileData Type="Normal" Path="hall_res/tongyong/bb_ty_gb1.png" Plist="" />
                <NormalFileData Type="Normal" Path="hall_res/tongyong/bb_ty_gb.png" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="icon_title" ActionTag="-928414237" Tag="106" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="403.0000" RightMargin="403.0000" TopMargin="14.3800" BottomMargin="559.6200" LeftEage="98" RightEage="98" TopEage="15" BottomEage="15" Scale9OriginX="98" Scale9OriginY="15" Scale9Width="23" Scale9Height="30" ctype="ImageViewObjectData">
                <Size X="219.0000" Y="60.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="512.5000" Y="589.6200" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.9300" />
                <PreSize X="0.2137" Y="0.0946" />
                <FileData Type="Normal" Path="hall_res/notice_service_setting/baobo_tc_title_xiaoxi.png" Plist="" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="640.0000" Y="360.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="0.8008" Y="0.8806" />
            <FileData Type="Normal" Path="hall_res/tongyong/bb_ty_tc.png" Plist="" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>