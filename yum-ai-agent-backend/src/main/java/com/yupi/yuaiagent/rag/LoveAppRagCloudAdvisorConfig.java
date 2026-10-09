package com.yupi.yuaiagent.rag;

// 云 RAG 顾问备选实验面——整类逐行注释化（智谱切换批）：import 依赖 com.alibaba.cloud.ai dashscope
// rag（随 alibaba starter 移除退役），反射内省 NoClassDefFoundError 实证（/tmp/yumai-boot2.log）；
// 恢复云 RAG 时连 pom 的 alibaba starter 注释块与 LoveApp 的 loveAppRagCloudAdvisor 字段一并解注释。
// 注：不用块注释包裹——类体 javadoc 的 */ 会提前闭合。
//
// /* 云 RAG 顾问备选实验面——整类注释化（智谱切换批）：
//    import 依赖 com.alibaba.cloud.ai dashscope rag（随 alibaba starter 移除退役），
//    反射内省 NoClassDefFoundError 实证（/tmp/yumai-boot2.log）；恢复云 RAG 时连
//    pom 的 alibaba starter 注释块与 LoveApp 的 loveAppRagCloudAdvisor 字段一并解注释。 */
//
// import com.alibaba.cloud.ai.dashscope.api.DashScopeApi;
// import com.alibaba.cloud.ai.dashscope.rag.DashScopeDocumentRetriever;
// import com.alibaba.cloud.ai.dashscope.rag.DashScopeDocumentRetrieverOptions;
// import lombok.extern.slf4j.Slf4j;
// import org.springframework.ai.chat.client.advisor.api.Advisor;
// import org.springframework.ai.rag.advisor.RetrievalAugmentationAdvisor;
// import org.springframework.ai.rag.retrieval.search.DocumentRetriever;
// import org.springframework.beans.factory.annotation.Value;
// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;
//
// /**
//  * 自定义基于阿里云知识库服务的 RAG 增强顾问
//  */
// @Configuration
// @Slf4j
// public class LoveAppRagCloudAdvisorConfig {
//
//     @Value("${spring.ai.dashscope.api-key}")
//     private String dashScopeApiKey;
//
//     @Bean
//     public Advisor loveAppRagCloudAdvisor() {
//         DashScopeApi dashScopeApi = DashScopeApi.builder()
//                 .apiKey(dashScopeApiKey)
//                 .build();
//         final String KNOWLEDGE_INDEX = "恋爱大师";
//         DocumentRetriever dashScopeDocumentRetriever = new DashScopeDocumentRetriever(dashScopeApi,
//                 DashScopeDocumentRetrieverOptions.builder()
//                         .withIndexName(KNOWLEDGE_INDEX)
//                         .build());
//         return RetrievalAugmentationAdvisor.builder()
//                 .documentRetriever(dashScopeDocumentRetriever)
//                 .build();
//     }
// }
// */
