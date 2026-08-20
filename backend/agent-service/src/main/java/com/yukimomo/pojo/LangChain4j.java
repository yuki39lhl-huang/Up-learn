package com.yukimomo.pojo;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@TableName("reservation")
public class LangChain4j {

    private Long id;

    private String name;

    private String gender;

    private String phone;

    private LocalDateTime communicationTime;

    private String province;

    private Integer estimatedScore;
}
